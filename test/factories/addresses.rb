FactoryBot.define do
  factory :address do
    line { Faker::Address.full_address  }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    zip_code { Faker::Address.zip_code }
    user
  end
end
