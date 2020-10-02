class CartLine < ApplicationRecord
  before_save :default_values

  belongs_to :cart
  belongs_to :product

  validates :cart_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true


  def default_values
    self.unit_type ||= 'Unit'
  end

end
