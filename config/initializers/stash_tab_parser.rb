# When server is started, calls PoE stash tab api and looks for maps with specific buyout
require 'http'

Thread.new do
  # Fetch next change id
  change_id = JSON.parse(HTTP.get('http://poe.ninja/api/Data/GetStats').to_s)['next_change_id']
  while true
    begin
      t = Time.now

      # Fetch stash data
      res = JSON.parse(HTTP.get('http://api.pathofexile.com/public-stash-tabs', :params => {:id => change_id}).to_s)

      # Set next change id
      change_id = res['next_change_id']

      # Parse stash tabs
      stashes = res['stashes']
      stashes.each do |tab|
        if tab['public']
          puts tab['id']
          #puts tab['accountName']
          #puts tab['stash']
        end
      end
      puts change_id
    rescue
      puts "Failed"
    ensure
      # Wait at least 1.1 seconds before each request
      sleep [t + 1.1 - Time.now, 0].max
    end
  end
end