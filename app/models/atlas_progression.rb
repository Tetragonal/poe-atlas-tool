# frozen_string_literal: true

class AtlasProgression < ApplicationRecord
  belongs_to :user
  has_one :map
  has_one :league

  def self.replace(maps, user, league)
    AtlasProgression.transaction do
      atlas_progressions = []
      AtlasProgression.where(user_id: user.id,
                             league_id: league.id).delete_all
      maps.each do |map_id|
        atlas_progressions << AtlasProgression.new(
          user_id: user.id,
          map_id: map_id,
          league_id: league.id
        )
      end
      AtlasProgression.import atlas_progressions
    end
    puts 'oof'
  end
end
