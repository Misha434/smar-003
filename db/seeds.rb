# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
3.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.org"
  password = "password"
  avatar = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/avatars/avatar-photo-#{n}.jpeg")), filename: "avatar-photo-#{n}.jpeg")
  User.create!(
    name:  name,
    email: email,
    password: password,
    password_confirmation: password,
    avatar: avatar 
    )
end

Review.create!(
  content: "Good",
  user_id: 1
  )

10.times do
  content = Faker::Lorem.sentence(word_count: 10)
  user_id = Faker::Number.within(range: 1..3)
  Review.create!(
    content: content,
    user_id: user_id,
  )
end