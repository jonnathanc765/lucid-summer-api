class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:show, :update_status]
    
    def index 
        if current_user.has_role? "admin" or current_user.has_role? "super-admin"
            @orders = Order.preload(:user, :order_lines) 
        else
            @orders = current_user.orders
        end
        render json: @orders, include: [:order_lines, :user], status: :ok
    end

    def create
        

        address = Address.find_by(id: order_params[:address_id].to_i)

        if address.nil?
            return render json: {message: 'Address must exists'}, status: :unprocessable_entity
        end

        if address.user_id != current_user.id
            return render json: {message: 'Current user is not the owner of this address'}, status: :unprocessable_entity
        end

        cart = current_user.cart

        if cart.cart_lines.empty?
            return render json: {message: 'Cart must have cart lines'}, status: :unprocessable_entity
        end

        order = current_user.orders.new(address: address[:line], city: address[:city], state: address[:state], country: address[:country], delivery_date: order_params[:delivery_date])

        if order.save!
            
            cart.cart_lines.each do |line|
                order.order_lines.create(product_id: line.product.id, quantity: line[:quantity], unit_type: line[:unit_type], price: line.product.retail_price)
            end
            cart.cart_lines.destroy_all
        end

        render json: order, include: [:order_lines], status: :created
    end

    def show
        render json: @order, include: [:user, order_lines: {include: [:product]}], status: :ok
    end

    def update_status

        
        if Order.statuses[@order.status] >= status_params[:status].to_i
            return render json: {message: 'Status must be valid'}, status: :unprocessable_entity
        end
        @order.update! status: status_params[:status].to_i
        render json: @order, status: :ok
    end


    private

    def order_params
        params.permit(:address_id, :delivery_date)
    end

    def set_order 
        @order = Order.preload(:user, order_lines: [:product]).find(params[:id].to_i)
    end

    def status_params
        params.permit(:status)
    end

end
