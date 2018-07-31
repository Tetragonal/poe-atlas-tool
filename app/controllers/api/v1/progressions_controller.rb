# frozen_string_literal: true

# localhost:3000/api/v1/progressions
class Api::V1::ProgressionsController < ActionController::API
  def post
    puts 'req ' + request.headers['HTTP_AUTHORIZATION'].to_s
    head :ok, content_type: 'text/html'
  end
end
