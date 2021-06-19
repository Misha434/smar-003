FactoryBot.define do
  factory :user do
    id { 1 }
    name { "Aaron" }
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end