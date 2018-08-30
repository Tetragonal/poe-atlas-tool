# frozen_string_literal: true

# When server is started, calls PoE stash tab api and looks for maps with specific buyout
require 'http'

class StashTabParser
  include Singleton

  def initialize
    Thread.new do
      loop do
        begin
          # Fetch next change id
          change_id = JSON.parse(HTTP.get('https://poe.ninja/api/Data/GetStats').to_s)['next_change_id']

          # create HTTP client with persistent connection
          http = HTTP.use(:auto_inflate)
                     .headers('Accept-Encoding' => 'gzip')
                     .persistent 'http://api.pathofexile.com'
          loop do
            begin
              t = Time.now

              # Fetch stash data
              res = JSON.parse(
                http.get('/public-stash-tabs', params: { id: change_id }).to_s
              )

              # Set next change id
              change_id = res['next_change_id']

              # Parse stash tabs
              stashes = res['stashes']
              stashes.each do |tab|
                next unless tab['public']

                cleared = false

                # Check each item in stash, looking for map
                tab_buyout = tab['stash'].to_s.include?('111 blessed')
                tab['items'].each do |item|
                  # Skip unless item has buyout and item is a map
                  next unless tab_buyout || item['note'].to_s.include?('111 blessed')
                  next unless item['category'].key?('maps')

                  puts 'found ' + item.to_s

                  # Get user from db
                  user = User.find_by username: tab['accountName']
                  break if user.nil?
                  # Update user's info TODO make sure works
                  user.update(last_character_name: tab['lastCharacterName']) unless user.last_character_name == tab['lastCharacterName']

                  # Get league id
                  league = League.find_by name: item['league']
                  break if league.nil?

                  # Clear existing data about stash if it exists
                  unless cleared
                    StashedMap.where(user_id: user.id,
                                     public_id: tab['id'],
                                     league_id: league.id).delete_all
                    cleared = true
                  end

                  # Get map id
                  map = Map.find_by(name: item['typeLine'].sub!(' Map', ''),
                                    atlas_version: Settings.ATLAS_VERSION)
                  break if map.nil?

                  StashedMap.create(user_id: user.id,
                                    map_id: map.id,
                                    public_id: tab['id'],
                                    league_id: league.id,
                                    x_coord: item['x'],
                                    y_coord: item['y'])
                end
              end
              puts change_id
            rescue StandardError => err
              puts 'Failed to get stash data'
              puts err
              sleep 5
            ensure
              # Wait at least 1.1 seconds between each request
              sleep [t + 1.1 - Time.now, 0].max
            end
          end
        rescue StandardError => err
          puts 'Connection to stash tab API failed'
          puts err
          sleep 5
        ensure
          # close underlying connection when you don't need it anymore
          http&.close
        end
      end
    end
  end
end

StashTabParser.instance if defined?(Rails::Server)
