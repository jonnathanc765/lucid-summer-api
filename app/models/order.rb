class Order < ApplicationRecord
  belongs_to :user
  has_many :order_lines

  validates :user_id, presence: true
  validates :address, presence: true
  validates :status, presence: true
end
