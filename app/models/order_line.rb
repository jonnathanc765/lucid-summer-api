class OrderLine < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :order_id, :product_id, :quantity, :unit_type, presence: true

end
