class Order < ApplicationRecord
  enum status: [:pending, :on_process, :to_deliver, :in_transit, :delivered, :rated, :cancelled]
  belongs_to :user
  has_many :order_lines
  has_many :reviews, as: :reviewable

  validates :user_id, :address, :city, :state, :country, :delivery_date, presence: true


  def subtotal 
    subtotal = 0
    self.order_lines.each do |order_line|
      subtotal += order_line.quantity * order_line.price
    end

    subtotal.truncate(2)
  end

  def total 
    (subtotal * 1.16).truncate 2
  end
end
