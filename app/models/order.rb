class Order < ApplicationRecord
  belongs_to :user
  has_many :order_lines
  before_save :default_values
  has_many :reviews, as: :reviewable

  validates :user_id, :address, :city, :state, :country, presence: true

  def default_values
    self.status = 0
  end
end
