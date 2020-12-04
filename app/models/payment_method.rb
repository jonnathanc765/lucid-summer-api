class PaymentMethod < ApplicationRecord
  belongs_to :user


  validates :unique_id, :user_id, presence: true
end
