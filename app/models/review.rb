class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  has_many :reviews, as: :reviewable


  validates :title, :description, :stars, presence: true
end
