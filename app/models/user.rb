class User < ApplicationRecord
  has_many :stashed_maps, dependent: :destroy
  has_many :atlas_progressions, dependent: :destroy

  def set_public(public)
    if public
      self.update(public_until: 12.hours.from_now)
    else
      self.update(public_until: Time.now)
    end
  end
end
