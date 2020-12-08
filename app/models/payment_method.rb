class PaymentMethod < ApplicationRecord
  belongs_to :user


  validates :unique_id, :user_id, :hashed_card_number, :card_brand, presence: true
end
