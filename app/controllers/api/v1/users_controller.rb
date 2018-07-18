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
    if params.has_key?(:account_name)
      response = PmComposer.instance.compose(
        params[:account_name],
        'API key',
        SecureRandom.uuid
      )
      # PoE site will return 302 Found on success, 200 OK on failure
      if response.code == "302"
        head :ok, content_type: "text/html"
      else
        head :internal_server_error, content_type: "text/html"
      end
    else
      head :bad_request, content_type: "text/html"
    end
  end
end
