# frozen_string_literal: true

# localhost:3000/api/v1/progressions
class Api::V1::ProgressionsController < ActionController::API
  def get
    user = User.find_by username: params[:account_name]
    return head :not_found if user.nil?

    # Filter by league id, if specified
    if params[:league_id]
      maps = AtlasProgression.where(user: user).where(league_id: params[:league_id]).select(:id, :map_id, :league_id)
    else
      maps = AtlasProgression.where(user: user).select(:id, :map_id, :league_id)
    end

    render json: {
        maps: maps
    }.to_json
  end

  def post
    # Find and authenticate user
    user = User.find_by username: params[:account_name]
    return head :bad_request if user.nil?
    return head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(request.headers['HTTP_AUTHORIZATION'].to_s, user.api_key)

    # Find league
    league = League.find_by name: params[:league]
    return head :bad_request if league.nil?

    # Replace user progression in league
    AtlasProgression.replace(params[:maps], user, league)
    head :ok
  end
end
