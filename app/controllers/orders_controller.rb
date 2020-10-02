class OrdersController < ApplicationController
    before_action :authenticate_user!
    
    def index 
        @orders = Order.all 
        render json: @orders, status: :ok
    end

end
