# frozen_string_literal: true

# localhost:3000/api/v1/login
class Api::V1::LoginController < ActionController::API
  def post
    user = User.find_by api_key: params[:api_key]
    return head :unauthorized if user.nil?
    else render json: {username: user.username}
  end
end
