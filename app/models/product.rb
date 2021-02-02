
class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many_attached :images, dependent: :destroy
  
  validates :name, :retail_price, :wholesale_price, :approximate_weight_per_piece, :sat, presence: true

  attribute :current_price

  def current_price 
    if !self.promotion_price.nil?
      return self.promotion_price
    else 
      return self.retail_price 
    end
  end

end
