# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Load maps

# Create fake user data
if Rails.env.development? do
  rng = Random.new(1234)
  Faker::Config.random = rng

  2000.times do
    user = User.new(
        username: Faker::User.unique.name,
        api_key: SecureRandom.uuid
    )

    # Make user's stashed maps
    rng.rand(0, 900).times do
      StashedMap.new(
          user_id: user.id,
          map_id: 1, # TODO
          public_id: Faker::Number.number(6),
          x_coord: rng.rand(0,15),
          y_coord: rng.rand(0,20)
      )
    end

    # Make user's atlas progression
    rng.rand(0, 300).times do
      AtlasProgression.new(
          user_id: user_id,
          map_id: 1 # TODO
      )
    end
  end
end