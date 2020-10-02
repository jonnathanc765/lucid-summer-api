class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true
  validates :unit_type, presence: true
end
