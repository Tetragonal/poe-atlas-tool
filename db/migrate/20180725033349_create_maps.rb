class CreateMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :maps do |t|
      t.string :name
      t.float :atlas_x
      t.float :atlas_y
      t.integer :atlas_version
      t.boolean :unique

      t.timestamps
    end
  end
end
