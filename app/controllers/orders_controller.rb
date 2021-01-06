class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:show, :update_status]
    
    def index 

        if current_user.has_any_role? "admin", "super-admin"
            @orders = Order.preload(:user, order_lines: [:product]).all
        elsif current_user.has_role? "dispatcher"
            @orders = Order.where(status: [:pending, :on_process])
        elsif current_user.has_role? "delivery-man"
            @orders = Order.where(status: [:to_deliver, :in_transit])
        else
            @orders = current_user.orders
        end

        @orders = @orders.map do |order|

            order_lines = order.order_lines.map do |order_line|

                product = order_line.product
                
                product.as_json.merge(
                    images: product.images.map { 
                        |image| { id: image.id, url: url_for(image) } 
                    }
                )

                order_line.as_json.merge(
                    product: product
                )
            end

            user = order.user.as_json()

            order.as_json.merge(
                order_lines: order_lines,
                user: user
            )
        end

        render json: @orders, status: :ok
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

        req_response = nil

        ActiveRecord::Base.transaction do

            if order.save!
                
                cart.cart_lines.each do |line|
                    order.order_lines.create(product_id: line.product.id, quantity: line[:quantity], unit_type: line[:unit_type], price: line.product.current_price)
                end

                cart.cart_lines.destroy_all
            end

            source = PaymentMethod.find(params[:payment_method_id])

            charges_details = {
                "method" => "card",
                "source_id" => source.unique_id,
                "amount" => order.total,
                "currency" => "MXN",
                "device_session_id": params[:device_session_id],
                "description" => "Cargo por pedido #00#{order.id}",
            }

            @openpay = OpenpayApi.new("mihqpo64jxhksuoohivz","sk_f6aafbacebd64882a224446b1331ef3c")

            @charges = @openpay.create(:charges)

            begin
                req_response = @charges.create(charges_details, current_user.customer_id)
                order.update!(payment_id: req_response["id"])
            rescue => exception
                
                raise ActiveRecord::Rollback 
                return render json: { message: exception.description }, status: exception.http_code     
            end

        end

        return render json: order.as_json(
            include: [:order_lines]
        )
        .merge(
            payment_details: req_response
        ), status: :created

    end

    def show
        render json: @order, include: [:user, order_lines: {include: [:product]}], status: :ok
    end

    def update_status

        @order.update! status: status_params[:status]
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
