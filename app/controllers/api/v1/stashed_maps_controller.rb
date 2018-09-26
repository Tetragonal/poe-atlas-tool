# frozen_string_literal: true

# localhost:3000/api/v1/stashed_maps
class Api::V1::StashedMapsController < ActionController::API
  def get
    user = User.find_by username: params[:account_name]
    return head :not_found if user.nil?

    # Filter by league id, if specified
    if params[:league_id]
      maps = StashedMap.where(user: user).where(league_id: params[:league_id]).select(:id, :map_id, :league_id)
    else
      maps = StashedMap.where(user: user).select(:id, :map_id, :league_id)
    end

    render json: {
        maps: maps
    }.to_json
  end
end
