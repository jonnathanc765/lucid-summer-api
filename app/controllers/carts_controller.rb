class CartsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    
    @cart = Cart.includes(cart_lines: [:product]).find_by(user_id: current_user.id)
    if @cart.nil?
      @cart = Cart.create!(user_id: current_user.id)
    end
    render json: @cart, include: [cart_lines: {include: [:product]}], status: :ok
  end
  
end
