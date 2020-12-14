class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_lines, dependent: :delete_all

  validates :user_id, presence: true
end
