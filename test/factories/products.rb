FactoryBot.define do
  factory :product do
    name { Faker::Food.fruits }
    retail_price { Faker::Number.decimal(l_digits: 2) }
    wholesale_price { Faker::Number.decimal(l_digits: 2) }
    promotion_price { Faker::Number.decimal(l_digits: 2) }
    approximate_weight_per_piece { Faker::Number.decimal(l_digits: 2) }
    exempt { Faker::Boolean::boolean }
    sat { "50301500" } # SAT for apples
    category
  end
end
