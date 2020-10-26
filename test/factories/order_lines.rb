FactoryBot.define do
    factory :order_line do
      order
      product
      quantity { Faker::Number.within(range: 1..100) }
      unit_type { ['Kg', 'Unidad', 'Gr', 'Racimo'].sample }
      price { Faker::Number.decimal(l_digits: 2) }
      check { Faker::Boolean.boolean }
    end
  end
  