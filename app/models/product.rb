class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many_attached :images
  
  validates :name, :retail_price, :wholesale_price, :approximate_weight_per_piece, presence: true
end
