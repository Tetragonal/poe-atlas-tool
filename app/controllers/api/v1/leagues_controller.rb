# frozen_string_literal: true

# localhost:3000/api/v1/admin/leagues
class Api::V1::LeaguesController < ActionController::API
  def get
    render json: {
      leagues: League.select(:id, :name, :active)
    }.to_json
  end

  def patch
    return head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(request.headers['HTTP_AUTHORIZATION'].to_s, Settings.ADMIN_KEY)
    return head :bad_request unless params[:active]

    league = League.find_by(name: params[:name])
    league.update(active: params[:active])
    head :ok
  end

  def post
    return head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(request.headers['HTTP_AUTHORIZATION'].to_s, Settings.ADMIN_KEY)

    League.find_or_create_by(name: params[:name], active: false)
    head :ok
  end

  def delete
    return head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(request.headers['HTTP_AUTHORIZATION'].to_s, Settings.ADMIN_KEY)

    League.find_by(name: params[:name]).delete
    head :ok
  end
end
