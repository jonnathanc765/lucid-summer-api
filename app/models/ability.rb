# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    can :read, Product
    can :read, Category

    if user.roles.count > 0
      if user.has_role? "super-admin"
        can :manage, :all
      end
    end

  end
end
