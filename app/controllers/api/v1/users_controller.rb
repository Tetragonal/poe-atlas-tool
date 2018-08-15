# frozen_string_literal: true

# localhost:3000/api/v1/user
class Api::V1::UsersController < ActionController::API
  def post
    # First check for invalid POESESSID
    return head :internal_server_error if PmComposer.instance.get_hash.nil?

    if params.key?(:account_name)
      # Create if exists, or get if doesn't exist
      user = User.find_by username: params[:account_name]

      api_key = if user.nil?
                  SecureRandom.uuid
                else
                  user.api_key
                end

      # 3 possibilities for response from PoE website:
      #   1. (Success) User exists and POESESSID valid:        302 Found
      #   2. (Failure) POESESSID invalid:                      302 Found
      #   3. (Failure) POESESSID valid but user doesn't exist: 200 OK

      # Send PM to user
      response = PmComposer.instance.compose(
        params[:account_name],
        'API key',
        api_key
      )

      if response.code == '302'
        # Create user if doesn't exist, return success
        if user.nil?
          User.create(username: params[:account_name],
                      api_key: api_key,
                      public_until: 1.day.ago)
        end
        head :ok
      elsif response.code == '200'
        # Couldn't send message, invalid PoE username
        head :not_found
      end
    else
      head :bad_request
    end
  end
end
