class CartsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    
    @cart = Cart.includes(cart_lines: [:product]).find_by(user_id: current_user.id)
    if @cart.nil?
      @cart = Cart.create!(user_id: current_user.id)
    end

    cart_line_parsed = @cart.cart_lines.map do |cart_line|
      cart_line.as_json.merge(
        product: cart_line.product.as_json.merge(
          images: cart_line.product.images.map { 
            |image| { id: image.id, url: url_for(image) } 
          } 
        )
      )
    end

    render json: @cart.as_json.merge(
      cart_lines: cart_line_parsed
    ), status: :ok
  end
  
end
