class CartsController < ApplicationController


    def show 

        if (current_user.cart)
            @cart = current_user.cart
        else
            @cart = Cart.new
            @cart.user = current_user
            @cart.save
        end

        render json: @cart, status: :ok

    end

end
