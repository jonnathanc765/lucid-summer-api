class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable, :recoverable, :rememberable
  include DeviseTokenAuth::Concerns::User
  rolify

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone, presence: true

  has_one_attached :avatar, dependent: :destroy
  has_many :addresses, dependent: :delete_all
  has_many :orders, dependent: :delete_all
  has_one :cart, dependent: :destroy
  has_many :payment_methods, dependent: :delete_all
  has_many :reviews, as: :reviewable, dependent: :delete_all

  after_create :assign_default_role
  
  attribute :isDispatcher
  attribute :isDeliveryMan

  def assign_default_role
    self.add_role 'client' if self.roles.blank?
  end

  def isDispatcher 
    self.has_role? "dispatcher"
  end

  def isDeliveryMan 
    self.has_role? "delivery-man"
  end

end
