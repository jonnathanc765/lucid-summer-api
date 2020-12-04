class Address < ApplicationRecord
  belongs_to :user


  validates :line, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :zip_code, presence: true
end
