class Api::V1::BaseController < ActionController::API
  # localhost:3000/api/v1/base
  def get
    render json: {
        message: SecureRandom.uuid()
    }.to_json
  end

  def post
    render json: {
        post: {:content => params[:content], :wasd => params[:asdf]}
    }.to_json
  end
end