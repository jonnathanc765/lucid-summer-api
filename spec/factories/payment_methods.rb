FactoryBot.define do
  factory :payment_method do
    unique_id { "MyString" }
    user { nil }
  end
end
