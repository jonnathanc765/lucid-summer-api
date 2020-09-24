class CartLine < ApplicationRecord
  belongs_to :cart
  belongs_to :product



  validates :cart_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true
end
