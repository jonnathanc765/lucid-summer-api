# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true


  has_one_attached :avatar
  
end
