class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many_attached :images

  validates :name, presence: true
  validates :retail_price, presence: true
  validates :wholesale_price, presence: true
end
