class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_lines

  validates :user_id, presence: true
end
