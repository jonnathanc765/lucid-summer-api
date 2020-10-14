class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  rolify

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true

  has_one_attached :avatar
  has_many :addresses
  has_many :orders
  has_one :cart

  after_create :assign_default_role
  

  def assign_default_role
    self.add_role 'client' if self.roles.blank?
  end

end
