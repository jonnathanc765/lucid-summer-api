class OrdersController < ApplicationController
    before_action :authenticate_user!
    
    def index 
        if current_user.has_role? "admin" or current_user.has_role? "super-admin"
            @orders = Order.all 
        else
            @orders = current_user.orders 
        end
        render json: @orders, status: :ok
    end

end
