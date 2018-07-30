# frozen_string_literal: true

require 'net/http'
require 'uri'

# localhost:3000/api/v1/user
class Api::V1::UsersController < ActionController::API
  def get
    render json: {
      test_message: SecureRandom.uuid
    }.to_json
  end

  def post
    # TODO: Check user database for existing user, resend token if found
    puts params
    if params.key?(:account_name)

      # Create if exists, or get if doesn't exist
      user = User.find_by username: params[:account_name]
      puts user.to_s
      api_key = if user.nil?
                  SecureRandom.uuid
                else
                  user.api_key
                end
      puts 'key ' + api_key
      # Send PM to user
      response = PmComposer.instance.compose(
        params[:account_name],
        'API key',
        api_key
      )
      puts response.code
      # PoE site will return 302 Found on success, 200 OK on failure
      if response.code == '302'
        # Create user if doesn't exist, return success
        if user.nil?
          User.create(username: params[:account_name],
                      api_key: api_key,
                      public_until: 1.day.ago)
        end
        head :ok, content_type: 'text/html'
      else
        head :internal_server_error, content_type: 'text/html'
      end
    else
      head :bad_request, content_type: 'text/html'
    end
  end
end
