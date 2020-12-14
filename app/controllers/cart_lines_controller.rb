class CartLinesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create

    @cart = Cart.includes(cart_lines: [:product]).find_by user_id: current_user.id

    if @cart.nil?
      @cart = Cart.create(user_id: current_user.id)
    end

    params[:cart_lines].each do |line|

      
      cart_line = @cart.cart_lines.create_with(quantity: line[:quantity]).find_or_create_by( product_id: line[:product_id])

      request_quantity = line[:quantity].to_i

      if request_quantity == 0
        cart_line.destroy 
      else
        cart_line.update! quantity: request_quantity
      end
      
    end

    render json: @cart.cart_lines.reload, include: [:product], status: :created
  end

  def update
    @cart_line.update!(update_params)
    render json: @cart_line, include: [:product], status: :ok
  end

  def destroy
    @cart_line.destroy

    render json: {message: 'Record deleted'}, status: :ok
  end

  private
  def set_cart_line
    @cart_line = CartLine.find params[:id]
  end
  def update_params
    params.permit(:quantity)
  end
end
