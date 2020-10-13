class Address < ApplicationRecord
  belongs_to :user


  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
end
