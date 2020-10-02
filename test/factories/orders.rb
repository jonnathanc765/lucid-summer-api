FactoryBot.define do
  factory :order do
    address { Faker::Address.street_address }
    state { Faker::Address.state }
    country { Faker::Address.country }
    status { Faker::Number.digit }
    user
  end
end
