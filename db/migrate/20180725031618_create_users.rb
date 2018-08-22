class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :last_character_name
      t.string :api_key

      t.timestamp :public_until

      t.timestamps
    end
  end
end
