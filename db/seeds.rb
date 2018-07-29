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
    is_unique = area_json[0]['data'][node[0]][69]

    puts name + ': ' + x.to_s + ' ' + y.to_s
    Map.create(
      name: name,
      atlas_x: x,
      atlas_y: y,
      unique: is_unique
    )
  end

  file.close
end

# Create fake user data
if Rails.env.development?
  rng = Random.new(1234)
  Faker::Config.random = rng

  2000.times do
    user = User.create(
      username: Faker::Name.unique.name,
      api_key: SecureRandom.uuid
    )

    # Make user's stashed maps
    rng.rand(0..200).times do
      StashedMap.create(
        user_id: user.id,
        map_id: 1, # TODO
        public_id: Faker::Number.number(6),
        x_coord: rng.rand(0..15),
        y_coord: rng.rand(0..20)
      )
    end

    # Make user's atlas progression
    rng.rand(0..150).times do
      AtlasProgression.create(
        user_id: user.id,
        map_id: 1 # TODO
      )
    end
  end
end
