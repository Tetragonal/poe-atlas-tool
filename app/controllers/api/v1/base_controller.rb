class Api::V1::BaseController < ActionController::API
  # localhost:3000/api/v1/base
  def index
    render json: {
        message: "Oof"
    }.to_json
  end
end