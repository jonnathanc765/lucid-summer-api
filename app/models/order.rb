class Order < ApplicationRecord
  belongs_to :user
  has_many :order_lines

  validates :user_id, presence: true
  validates :address, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :status, presence: true
end
