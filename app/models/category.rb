class Category < ApplicationRecord
  before_save :default_values
  has_many :products, dependent: :nullify
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_category", optional: true

  def default_values
    self.color ||= '#FFFFFF'
  end

  validates :name, presence: true
end
