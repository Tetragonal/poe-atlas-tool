require 'nokogiri'
require 'http'

# Periodically refresh PoE compose webpage to maintain an updated security token
class PmComposer
  include Singleton

  def initialize
    Thread.new do
      loop do
        begin
          t = Time.now

          # Use nokogiri to retrieve form, get value of 'hash' for use in form
          html = Nokogiri::HTML(HTTP.cookies(POESESSID: Settings.POESESSID)
                                    .get('https://www.pathofexile.com/private-messages/compose').to_s)

          # Set class-variable to be used later to fill out form
          @hash = html.at_css('input#hash')['value']
          puts @hash
        rescue StandardError
          puts 'Failed to load form data, retrying in 5 seconds'
          sleep 5
        ensure
          # Wait at least 10 minutes between each request
          sleep [t + (10 * 60) - Time.now, 0].max
        end
      end
    end
  end

  def compose(recipient, subject, content)
    uri = URI.parse('https://www.pathofexile.com/private-messages/compose')
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/x-www-form-urlencoded'
    request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:61.0) Gecko/20100101 Firefox/61.0'
    request['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    request['Accept-Language'] = 'en-US,en;q=0.5'
    request['Referer'] = 'https://www.pathofexile.com/private-messages/compose'
    request['Cookie'] = 'POESESSID=' + Settings.POESESSID
    request['Dnt'] = '1'
    request['Connection'] = 'keep-alive'
    request['Upgrade-Insecure-Requests'] = '1'
    request.set_form_data(
      'add_recipient' => recipient,
      'bcc_recipients[total_accounts]' => '0',
      'content' => content,
      'hash' => @hash,
      'subject' => subject,
      'submit' => 'Submit',
      'to_recipients[total_accounts]' => '0'
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    # Return the request body
    Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end
end

# Initialize singleton
PmComposer.instance
