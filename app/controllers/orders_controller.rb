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

    def create

        
        address = Address.find(params[:address_id])
        cart = current_user.cart
        order = current_user.orders.new(address: address[:address], city: address[:city], state: address[:state], country: address[:country])
        order.status = 0
        if order.save 
            cart.cart_lines.each do |line|
                product = Product.find(line[:product_id])
                order.order_lines.create(product_id: line[:product_id], quantity: line[:quantity], unit_type: line[:unit_type], price: product.retail_price)
            end
            cart.cart_lines.destroy_all
        end

        render json: order, include: [:order_lines], status: :created
    end
            



end
