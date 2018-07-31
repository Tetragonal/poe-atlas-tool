# frozen_string_literal: true

# localhost:3000/api/v1/admin/leagues
class Api::V1::LeaguesController < ActionController::API
  def get
    puts 'req ' + request.headers['HTTP_AUTHORIZATION'].to_s
    head :ok
  end


  def post
    head :unauthorized unless request.headers['HTTP_AUTHORIZATION'].to_s == Settings.ADMIN_KEY

    League.find_or_create_by(name: params[:name])
    head :ok
  end

  def delete
    head :unauthorized unless request.headers['HTTP_AUTHORIZATION'].to_s == Settings.ADMIN_KEY

    League.find_by(name: params[:name]).delete
    head :ok
  end

end
