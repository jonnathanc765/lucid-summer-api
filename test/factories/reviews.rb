FactoryBot.define do
  factory :review do

    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentences(number: 3)[0] }
    stars { Faker::Number.within(range: 1..5) }
    for_order 

    trait :for_user do
      association :reviewable, factory: :user
    end

    trait :for_order do
      association :reviewable, factory: :order
    end
  end
end
