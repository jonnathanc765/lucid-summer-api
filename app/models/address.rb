class Address < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :address, presence: true
  validates :state, presence: true
  validates :country, presence: true
end
