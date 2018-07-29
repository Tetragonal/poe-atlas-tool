class CreateStashedMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :stashed_maps do |t|
      t.references :user, foreign_key: true
      t.references :map, foreign_key: true
      t.references :league, foreign_key: true
      t.integer :public_id
      t.integer :x_coord
      t.integer :y_coord

      t.timestamps
    end
  end
end
