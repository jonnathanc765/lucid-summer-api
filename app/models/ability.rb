# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    # Define permissions for not logged in user here 
    can :read, Product
    can :read, Category

    if user.present?

      can :manage, Address

      if user.has_role? "super-admin"
        can :manage, :all
      end

      if user.has_role? "client"
        can :manage, Cart
        can :manage, CartLine
      end
    end
  end
end
