class Order < ApplicationRecord
  enum status: [:pending, :on_process, :to_deliver, :in_transit, :delivered, :rated]
  belongs_to :user
  has_many :order_lines
  before_save :default_values

  validates :user_id, :address, :city, :state, :country, presence: true

  def default_values
    self.status = 0
  end
end
