class CreateMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :maps do |t|
      t.string :name
      t.integer :atlas_x
      t.integer :atlas_y
      t.integer :atlas_version

      t.timestamps
    end
  end
end
