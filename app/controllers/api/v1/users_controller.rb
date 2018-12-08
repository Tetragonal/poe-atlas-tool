# frozen_string_literal: true

# localhost:3000/api/v1/user
class Api::V1::UsersController < ActionController::API

  USERS_TO_QUERY = 50
  def random_get
    return head :bad_request if User.find_by(username: params[:account_name]).nil?
    return head :bad_request if League.find_by(id: params[:league_id]).nil?

    # Get 50 random user ids
    user_ids = AtlasProgression
                   .joins(:user)
                   .where(['users.public_until > ?', Time.now()])
                   .where.not(users: {username: params[:account_name]})
                   .where(league_id: params[:league_id])
                   .select(:user_id, :last_character_name)
                   .distinct
                   .order_by_rand
                   .limit(USERS_TO_QUERY)
                   .map(&:user_id)

    trade_data = {}

    # Get their progressions
    AtlasProgression
        .joins(:user)
        .where(user_id: user_ids)
        .select(:id, :last_character_name, :map_id)
        .find_each do |progression|
      trade_data[progression.last_character_name] ||= {}
      trade_data[progression.last_character_name]['progressions'] ||= []
      trade_data[progression.last_character_name]['progressions'] << progression.map_id
    end

    # Get their stashed maps
    StashedMap
        .joins(:user)
        .where(user_id: user_ids)
        .select(:id, :last_character_name, :map_id)
        .find_each do |stashed_map|
      trade_data[stashed_map.last_character_name] ||= {}
      trade_data[stashed_map.last_character_name]['stashed_maps'] ||= Set[]
      trade_data[stashed_map.last_character_name]['stashed_maps'].add(stashed_map.map_id)
    end

    # Initialize undefined
    trade_data.each do |_, user_data|
      user_data['progressions'] ||= []
      user_data['stashed_maps'] ||= []
    end

    render json: trade_data.to_json
  end

  def set_public
    user = User.find_by(username: params[:account_name])

    return head :bad_request if user.nil?
    return head :bad_request if params[:api_key].nil?
    return head :bad_request if [true, false].exclude?(params[:public])

    return head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(params[:api_key], user.api_key)

    user.set_public(params[:public])
    head :ok
  end

  def post
    # First check for invalid POESESSID
    return head :internal_server_error if PmComposer.instance.get_hash.nil?

    if params.key?(:account_name)
      # Create if exists, or get if doesn't exist
      user = User.find_by username: params[:account_name]

      api_key = if user.nil?
                  SecureRandom.uuid
                else
                  user.api_key
                end

      # 3 possibilities for response from PoE website:
      #   1. (Success) User exists and POESESSID valid:        302 Found
      #   2. (Failure) POESESSID invalid:                      302 Found
      #   3. (Failure) POESESSID valid but user doesn't exist: 200 OK

      # Send PM to user
      response = PmComposer.instance.compose(
        params[:account_name],
        'API key (poeatlastool.xyz)',
        api_key
      )

      if response.code == '302'
        # Create user if doesn't exist, return success
        if user.nil?
          User.create(username: params[:account_name],
                      api_key: api_key,
                      public_until: 1.day.ago)
        end
        head :ok
      elsif response.code == '200'
        # Couldn't send message, invalid PoE username
        head :not_found
      end
    else
      head :bad_request
    end
  end
end
