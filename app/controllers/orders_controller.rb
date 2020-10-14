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

        address = Address.find_by(id: order_params.to_i)

        if address.user_id != current_user.id
            return render json: {message: 'Current user is not the owner of this address'}, status: :unprocessable_entity
        end

        cart = current_user.cart

        if cart.cart_lines.empty?
            return render json: {message: 'Cart must have cart lines'}, status: :unprocessable_entity
        end

        order = current_user.orders.new(address: address[:address], city: address[:city], state: address[:state], country: address[:country])

        if order.save!
            
            cart.cart_lines.each do |line|
                order.order_lines.create(product_id: line.product.id, quantity: line[:quantity], unit_type: line[:unit_type], price: line.product.retail_price)
            end
            cart.cart_lines.destroy_all
        end

        render json: order, include: [:order_lines], status: :created
    end

    private
        def order_params
            params.require(:address_id)
        end
            



end
