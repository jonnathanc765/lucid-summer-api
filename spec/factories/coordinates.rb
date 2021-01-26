FactoryBot.define do
  factory :coordinate do
    zip_code { Faker::Address.zip }
  end
end
