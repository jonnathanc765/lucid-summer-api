# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    # Define permissions for not guest users here 
    can :read, Product
    can :read, Category
    can :read, Review
    can :read_limited_categories, Category

    if user.present?

      can :manage, Address, user_id: user.id

      if user.has_role? "super-admin"
        can :manage, :all
      end

      if user.has_role? "admin"
        can :manage, User
        can :manage, Product 
        can :manage, Category
        can :manage, Review
        can :attach_images, Product
      end

      if user.has_role? "client"
        can :manage, Cart
        can :manage, CartLine
        can :manage, Order, user_id: user.id
        can [:create], Review
        can [:create], User
        can :show, User, id:user.id
      end
    end
  end
end
