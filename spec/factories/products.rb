FactoryBot.define do
  factory :product do
    id { 1 }
    name { "Phone-1" }
    soc_antutu_score { 1000 }
    battery_capacity { 1000 }
    brand_id { 1 }
    release_date { DateTime.now }
  end
end
