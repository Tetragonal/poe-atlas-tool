# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'

# Load Atlas data
atlas_path = File.expand_path('../vendor/atlas/AtlasNodes', __dir__)
areas_path = File.expand_path('../vendor/atlas/WorldAreas', __dir__)

Dir.foreach(atlas_path) do |filename|
  next if filename == '.' || filename == '..'

  # Load corresponding world areas data
  puts 'Loading WorldAreas file ' + filename
  area_file = File.open(File.join(areas_path, filename), 'r')
  area_json = JSON.parse(area_file.read)

  # Load Atlas nodes
  puts 'Loading AtlasNodes file ' + filename
  file = File.open(File.join(atlas_path, filename), 'r')
  atlas_json = JSON.parse(file.read)
  atlas_json[0]['data'].each do |node|
    name = area_json[0]['data'][node[0]][1]
    x = node[1] - 8
    y = node[2] - 55
    tier = node[10]
    is_unique = area_json[0]['data'][node[0]][69]

    printf "%-25s: x=%-20s y=%-20s tier=%-4s unique=%s\n",
           name, x.to_s, y.to_s, tier.to_s, is_unique.to_s
    Map.create(
      name: name,
      atlas_x: x,
      atlas_y: y,
      tier: tier,
      unique: is_unique,
      atlas_version: Settings.ATLAS_VERSION
    )
  end

  file.close
end

# Add leagues
League.create(
  name: 'Standard'
)

League.create(
  name: 'Hardcore'
)

# Create fake user data
if Rails.env.development?
  rng = Random.new(1234)
  Faker::Config.random = rng

  map_count = Map.where('atlas_version = ' + Settings.ATLAS_VERSION.to_s).count
  puts map_count

  2000.times do |i|
    puts 'User #' + i.to_s
    user = User.create(
      username: Faker::Name.unique.first_name,
      api_key: SecureRandom.uuid,
      public_until: 1.days.from_now
    )

    # Make user's stashed maps
    stashed_maps = []
    a = (1..map_count).to_a.shuffle
    rng.rand(0..map_count).times do
      stashed_maps << StashedMap.new(
        user_id: user.id,
        map_id: a.pop,
        league_id: 1, # TODO
        public_id: Faker::Number.number(6),
        x_coord: rng.rand(0..15),
        y_coord: rng.rand(0..20)
      )
    end
    StashedMap.import stashed_maps

    # Make user's atlas progression
    atlas_progressions = []
    a = (1..map_count).to_a.shuffle
    rng.rand(0..map_count).times do
      atlas_progressions << AtlasProgression.new(
        user_id: user.id,
        map_id: a.pop,
        league_id: 1 # TODO
      )
    end
    AtlasProgression.import atlas_progressions
  end
end
