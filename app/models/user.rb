class User < ApplicationRecord
  has_many :stashed_maps, dependent: :destroy
  has_many :atlas_progressions, dependent: :destroy
end
