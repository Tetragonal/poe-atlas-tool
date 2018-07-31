# frozen_string_literal: true

# localhost:3000/api/v1/progressions
class Api::V1::ProgressionsController < ActionController::API
  def get
    render json: {
        test_message: SecureRandom.uuid
    }.to_json
  end
end
