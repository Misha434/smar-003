require 'securerandom'

20.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.email
  password = SecureRandom.hex(16)
  avatar = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/avatars/avatar-photo-#{n}.jpeg")), filename: "avatar-photo-#{n}.jpeg")
  User.create!(
    name:  name,
    email: email,
    password: password,
    password_confirmation: password,
    avatar: avatar 
    )
end

Brand.create!(
  name: "brand-0"
  )

Faker::Config.locale = :en
19.times do |n|
  name = Faker::Company.name
  image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/brands/brand-photo-#{n}.jpeg")),
  filename: "brand-photo-#{n}.jpeg")
  Brand.create!(
    name: name,
    image: image,
  )
end

Product.create!(
  name: "SmartPhone 0",
  soc_antutu_score: 100000,
  battery_capacity: 5000,
  brand_id: 1,
  release_date: DateTime.now,
  image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/product_fujitsu_1.jpeg")),
  filename: "product_fujitsu_1.jpeg")
  )

18.times do |n|
  name = Faker::Drone.name
  soc_antutu_score = rand(211737..820936)
  battery_capacity = rand(1000..10000)
  brand_id = Faker::Number.within(range: 1..19)
  release_date = DateTime.now - n - 1
  image = ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("frontend/images/products/product-photo-#{n}.jpeg")),
  filename: "product-photo-#{n}.jpeg")
  Product.create!(
    name: name,
    soc_antutu_score: soc_antutu_score,
    battery_capacity: battery_capacity,
    brand_id: brand_id,
    image: image,
    release_date: release_date
  )
end

Faker::Config.locale = :ja

Review.create!(
  content: "Good",
  user_id: 1,
  product_id: 1,
  rate: 3
  )
10.times do
  good_bad = ["いい", "普通", "まあまあ", "そこそこ", "それなり"][rand(0..4)]
  use_case = ["ゲームをやるの", "日常使い", "電話のみ", "動画をみる", "LINEのみ"][rand(0..4)]
  content = "バッテリー持ちは#{good_bad}、動作は#{good_bad}。#{use_case}には#{good_bad}。（これはデモデータです）"
  user_id = Faker::Number.within(range: 2..20)
  product_id = Faker::Number.within(range: 2..19)
  rate = rand(1..5)
  Review.create!(
    content: content,
    user_id: user_id,
    product_id: product_id,
    rate: rate
  )
end

Like.create!(
  user_id: 1,
  review_id: 1,
  )
  
10.times do
  user_id = rand(2..20)
  review_id = rand(2..10)
  Like.create!(
    user_id: user_id,
    review_id: review_id,
    )
end