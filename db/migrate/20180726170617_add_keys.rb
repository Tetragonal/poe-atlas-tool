class AddKeys < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key "atlas_progressions", "users", name: "atlas_progressions_user_id_fk"
    add_foreign_key "stashed_maps", "users", name: "stashed_maps_user_id_fk"
  end
end
