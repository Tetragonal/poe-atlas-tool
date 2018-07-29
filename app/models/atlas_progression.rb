class AtlasProgression < ApplicationRecord
  belongs_to :user
  has_one :map
  has_one :league
end
