FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number  }
    email { Faker::Internet.unique.email }
    password { "password" }
  end
end
