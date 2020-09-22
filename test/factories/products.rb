FactoryBot.define do
  factory :product do
    name { Faker::Food.vegetables }
    retail_price { Faker::Number.decimal(l_digits: 2) }
    wholesale_price { Faker::Number.decimal(l_digits: 2) }
    promotion_price { Faker::Number.decimal(l_digits: 2) }
    approximate_weight_per_piece { Faker::Number.decimal(l_digits: 2) }
    user { :user }
  end
end
