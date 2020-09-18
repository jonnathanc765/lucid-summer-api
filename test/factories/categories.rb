FactoryBot.define do
  factory :category do
    name { Faker::Verb.simple_present }
    description { Faker::Verb.past }
  end
end
