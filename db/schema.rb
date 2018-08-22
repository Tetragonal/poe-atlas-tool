# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_26_170617) do

  create_table "atlas_progressions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "map_id"
    t.integer "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_atlas_progressions_on_league_id"
    t.index ["map_id"], name: "index_atlas_progressions_on_map_id"
    t.index ["user_id"], name: "index_atlas_progressions_on_user_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maps", force: :cascade do |t|
    t.string "name"
    t.float "atlas_x"
    t.float "atlas_y"
    t.integer "tier"
    t.integer "atlas_version"
    t.boolean "unique"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stashed_maps", force: :cascade do |t|
    t.integer "user_id"
    t.integer "map_id"
    t.integer "league_id"
    t.integer "public_id"
    t.integer "x_coord"
    t.integer "y_coord"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_stashed_maps_on_league_id"
    t.index ["map_id"], name: "index_stashed_maps_on_map_id"
    t.index ["user_id"], name: "index_stashed_maps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "last_character_name"
    t.string "api_key"
    t.datetime "public_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
