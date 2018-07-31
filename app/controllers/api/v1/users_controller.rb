# frozen_string_literal: true

require 'net/http'
require 'uri'

# localhost:3000/api/v1/user
class Api::V1::UsersController < ActionController::API
  def post
    if params.key?(:account_name) && !PmComposer.instance.hash.nil?

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
        head :ok
      else
        head :internal_server_error
      end
    else
      head :bad_request
    end
  end
end
