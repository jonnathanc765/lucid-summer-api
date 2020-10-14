class Order < ApplicationRecord
  belongs_to :user
  has_many :order_lines

  validates :user_id, :address, :city, :state, :country, :status, presence: true
end
