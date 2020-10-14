FactoryBot.define do
  factory :address do
    address { Faker::Address.full_address  }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    user
  end
end
