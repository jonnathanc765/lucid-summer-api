class Order < ApplicationRecord
  enum status: [:pending, :on_process, :to_deliver, :in_transit, :delivered, :rated]
  belongs_to :user
  has_many :order_lines

  validates :user_id, :address, :city, :state, :country, presence: true

end
