# frozen_string_literal: true

# localhost:3000/api/v1/maps
class Api::V1::MapsController < ActionController::API
  def get
    render json: {
      maps: Map.where(atlas_version: Settings.ATLAS_VERSION).select(:id, :name, :atlas_x, :atlas_y, :tier, :unique)
    }.to_json
  end
end
