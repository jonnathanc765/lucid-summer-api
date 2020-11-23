class Category < ApplicationRecord
  before_save :default_values
  has_many :products, dependent: :nullify
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_category_id", optional: true
  has_many :limited_products, -> { limit(10) }, class_name: 'Product'


  def default_values
    self.color ||= '#FFFFFF'
  end


  validates :name, presence: true
  
  validates(
    :parent_category,
    presence: true,
    if: :parent_category_id?
  )
  validates(
    :parent_category_id,
    numericality: {
      other_than: :id
    },
    on: :update,
    if: :parent_category_id?
  )
end
