class CartLinesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    @cart = Cart.first_or_create user_id: current_user.id

    params[:cart_lines].each do |line|
      
      cart_line = @cart.cart_lines.find_or_create_by product_id: line[:product_id]
      cart_line_quantity = cart_line.quantity
      request_quantity = line[:quantity].to_i

      if request_quantity == 0
        cart_line.destroy 
      else
        cart_line.update! quantity: cart_line_quantity.nil? ? request_quantity : cart_line_quantity + request_quantity
      end
      
    end

    render json: @cart.cart_lines, status: :created
  end

  def destroy
    @cart_line.destroy

    render json: {message: 'Record deleted'}, status: :ok
  end

  private
    def set_cart_line
      @cart_line = CartLine.find params[:id]
    end
end
