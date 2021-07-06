FactoryBot.define do
  factory :review do
    id { 1 }
    content { "Awesome" }
    user_id { 1 }
    product_id { 1 }
    rate { 3 }
  end
end
