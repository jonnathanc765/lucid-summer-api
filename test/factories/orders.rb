FactoryBot.define do
  factory :order do
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    user
  end
end
