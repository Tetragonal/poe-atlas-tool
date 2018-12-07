require 'nokogiri'
require 'open-uri'

# Periodically refresh PoETrade name -> id dictionary
class PoetradeConverter
  include Singleton

  attr_reader :name_to_id
  attr_reader :currency_to_id

  def initialize
    Thread.new do
      loop do
        begin
          t = Time.now

          name_to_id = {}
          currency_to_id = {}

          # Use nokogiri to retrieve PoETrade name => id, e.g. {"Abyss"=>315, "Academy"=>316}
          html = Nokogiri::HTML(open('http://currency.poe.trade/'))
          map_list = html.at_css('div#cat-want-3').at('.selector-contents').css('.currency-selectable')

          map_list.each do |elem|
            name_to_id[elem['data-title']] = elem['data-id'].to_i
          end

          currency_list = html.at_css('div#cat-want-0').at('.selector-contents').css('.currency-selectable')

          currency_list.each do |elem|
            currency_to_id[elem['data-title']] = elem['data-id'].to_i
          end

          puts name_to_id
          puts currency_to_id

          @name_to_id = name_to_id
          @currency_to_id = currency_to_id

          # Wait at least 30 minutes between each request
          sleep [t + (30 * 60) - Time.now, 0].max

        rescue StandardError
          puts 'Failed to load PoETrade ids, retrying in 5 seconds'
          sleep 5
        end
      end
    end
  end
end

# Initialize singleton
PoetradeConverter.instance if defined?(Rails::Server)
