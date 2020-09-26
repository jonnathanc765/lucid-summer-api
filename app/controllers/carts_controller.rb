class CartsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    @cart = Cart.first_or_create user_id: current_user.id
    render json: @cart, include: [:cart_lines], status: :ok
  end
end
