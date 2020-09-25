class CartLinesController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource

    def create

        @cart = Cart.first_or_create user_id: current_user.id

        params[:cart_lines].each do |line|
            
            cart_line = @cart.cart_lines.where(product_id: line[:product_id]).first

            
            if cart_line
                
                quantity = line[:quantity].to_i + cart_line[:quantity]
                cart_line.update(quantity: quantity, product_id: line[:product_id])
            else 
                @cart.cart_lines.create!(quantity: line[:quantity], product_id: line[:product_id])
            end

        end

        render json: @cart.cart_lines, status: :ok

    end


end
