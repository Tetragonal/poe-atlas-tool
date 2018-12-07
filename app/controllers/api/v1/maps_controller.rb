# frozen_string_literal: true

# localhost:3000/api/v1/maps
class Api::V1::MapsController < ActionController::API
  def get
    return head :internal_server_error if PoetradeConverter.instance.name_to_id.nil?
    return head :internal_server_error if PoetradeConverter.instance.currency_to_id.nil?

    render json: {
      maps: Map.where(atlas_version: Settings.ATLAS_VERSION).select(:id, :name, :atlas_x, :atlas_y, :tier, :unique),
      poe_trade_maps: PoetradeConverter.instance.name_to_id,
      poe_trade_currency: PoetradeConverter.instance.currency_to_id
    }.to_json
  end
end
