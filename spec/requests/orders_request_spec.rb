require 'rails_helper'
require 'support/orders_requests_helpers'





RSpec.configure do |config|
  config.include OrdersRequestsHelpers
end

RSpec.describe "Orders ~>", type: :request do

  describe 'Guest users ~>' do
    describe "GET /orders" do
      it 'users must be logged in for see its orders' do

        get "/orders"
        expect(response).to have_http_status(401)

      end

      it 'users must be logged in for generate orders' do

        post "/orders"
        expect(response).to have_http_status(401)

      end
    end


  end

  describe 'Logged in users ~>' do

    # Necesaries vars 

    let(:openpay) do 
      openpay = OpenpayApi.new("mihqpo64jxhksuoohivz","sk_f6aafbacebd64882a224446b1331ef3c")
      openpay 
    end
  
    let(:client_user) do
      user = create(:user)
      user.add_role "client" 
      user
    end
  
    sign_in(:client_user)
  
    let(:valid_address) do
      create(:address, user_id: client_user.id)
    end
  
    let(:customer) do 
  
      @customer = openpay.create(:customers)
  
      customer_payload = {
        "name" => client_user.first_name,
        "last_name" => client_user.last_name,
        "email" => client_user.email,
        "requires_account" => false,
        "phone_number" => client_user.phone,
        "address" => {
          "line1" => valid_address.line,
          "line2" => nil,
          "line3" => nil,
          "state" => valid_address.state,
          "city" => valid_address.city,
          "postal_code" => valid_address.zip_code,
          "country_code" => "MX"
        }
      }
  
      response = @customer.create(customer_payload)
      client_user.customer_id = response["id"]
      client_user.save!
  
      response
    end
  
    let(:card) do
      customer
  
      @cards = openpay.create(:cards)
  
      req_payload = {
        :holder_name => "Juan Perez Ramirez",
        :card_number => "4242424242424242",
        :cvv2 => "110",
        :expiration_month => "12",
        :expiration_year => "25",
        :device_session_id => "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f",
        :address => {
          :line1 => valid_address.line,
          :line2 => nil,
          :line3 => nil,
          :state => valid_address.state,
          :city => valid_address.city,
          :postal_code => valid_address.zip_code,
          :country_code => "MX"
        }
      }

      response = @cards.create(req_payload, client_user.customer_id)

      response
    end

    sign_in(:client_user)

    describe 'open pay integration' do
      
      it 'the payment it is successful' do

        card # instance of card with open pay

        product1 = create(:product)
        product2 = create(:product)
        product3 = create(:product)

        cart = Cart.create(user_id: client_user.id)

        cart.cart_lines.create(quantity: 1, product_id: product1.id)
        cart.cart_lines.create(quantity: 1, product_id: product2.id)
        cart.cart_lines.create(quantity: 1, product_id: product3.id)

        total = 52.2 # Total with taxes (16 % more)

        address = create(:address, user_id: client_user.id)

        time = Time.now

        payment_method = PaymentMethod.create(unique_id: card["id"], user_id: client_user.id, hashed_card_number: card["card_number"], card_brand: 1)

        post "/orders", params: {address_id: address.id, delivery_date: time, payment_method_id: payment_method.id, device_session_id: "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f"}

        expect(response).to have_http_status(:created)
        expect(payload).to_not be_nil  
        expect(payload["payment_details"]).to_not be_nil


      end
      
      describe 'Invalids cards (messages)' do

        it 'insufficient funds' do

          cart = create_cart client_user

          customer
          
          card_response = create_invalid_card openpay, "4444444444444448", valid_address, customer["id"]
          
          time = Time.now

          payment_method = PaymentMethod.create(unique_id: card_response["id"], user_id: client_user.id, hashed_card_number: card_response["card_number"], card_brand: 1)

          post "/orders", params: {address_id: valid_address.id, delivery_date: time, payment_method_id: payment_method.id, device_session_id: "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f"}

          expect(response).to have_http_status(402)
          expect(payload).to_not be_empty 
          expect(payload["message"]).to_not be_nil 
          expect(payload["message"]).to eq("The card doesn't have sufficient funds")
          
        end

        it 'insufficient funds' do

          cart = create_cart client_user

          customer
          
          card_response = create_invalid_card openpay, "4000000000000119", valid_address, customer["id"]
          
          time = Time.now

          payment_method = PaymentMethod.create(unique_id: card_response["id"], user_id: client_user.id, hashed_card_number: card_response["card_number"], card_brand: 1)

          post "/orders", params: {address_id: valid_address.id, delivery_date: time, payment_method_id: payment_method.id, device_session_id: "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f"}

          expect(response).to have_http_status(402)
          expect(payload).to_not be_empty 
          expect(payload["message"]).to_not be_nil 
          expect(payload["message"]).to eq("The card was reported as stolen")
          
        end
        
      end
    end

    describe "GET /orders ~>" do

      it "Users can see its orders" do
        orders = create_list(:order, 10, user_id: client_user.id)
        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(10)
        expect(payload[0]['id']).to eq(orders[0]['id'])
      end

      it 'users only can see only its orders' do
        create_list(:order, 10)
        orders = create_list(:order, 4, user_id: client_user.id)
        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(4)
        expect(payload[0]['id']).to eq(orders[0]['id'])
      end

      it 'admin and super admin can see all orders' do

        create_list(:order, 10)
        orders = create_list(:order, 4, user_id: client_user.id)

        client_user.remove_role 'client'
        client_user.add_role 'admin'

        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(14)

        client_user.remove_role 'admin'
        client_user.add_role 'super-admin'

        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(14)

      end

    end

    describe 'POST /orders ~>' do
      it 'client can generate a order' do

        cart = create_cart client_user

        payment_method = PaymentMethod.create(unique_id: card["id"], user_id: client_user.id, hashed_card_number: card["card_number"], card_brand: card["brand"])

        address = create(:address, user_id: client_user.id)
        
        time = Time.now

        post "/orders", params: { address_id: address.id, delivery_date: time, payment_method_id: payment_method.id, device_session_id: "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f" }

        order = Order.first

        expect(response).to have_http_status(:created)
        expect(payload).to_not be_empty
        expect(payload["status"]).to eq("pending")
        expect(payload["address"]).to eq(address.line)
        expect(payload["delivery_date"]).to_not be_nil
        expect(order.delivery_date).to_not be_nil
        expect(payload['order_lines'].size).to eq(10)
        expect(CartLine.all.size).to eq(0)

      end
    
      it 'address is required for generate a order' do

        cart = create_cart client_user

        address = create(:address, user_id: client_user.id)

        post "/orders"

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.all.size).to eq(0)
      end

      it 'must exists cart lines of current user' do

        cart = create_cart client_user, false

        address = create(:address, user_id: client_user.id)

        post "/orders", params: {address_id: address.id}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.all.size).to eq(0)

      end
      it 'current user must be owner of id address sent it' do

        cart = create_cart client_user

        addresses = create_list(:address, 4)

        address = create(:address, user_id: client_user.id)

        post "/orders", params: {address_id: addresses[2].id}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.all.size).to eq(0)
        expect(OrderLine.all.size).to eq(0)

      end

      it 'address must exists' do

        cart = create_cart client_user

        address = create(:address, user_id: client_user.id)

        post "/orders", params: {address_id: 422}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.all.size).to eq(0)
        expect(OrderLine.all.size).to eq(0)

      end
    end

    describe 'GET /orders/:id ~>' do
      it 'it retieve a order' do

        order = create_order user

        get "/orders/#{order.id}"

        expect(response).to have_http_status(:ok)
        expect(payload).to_not be_empty
        expect(payload['order_lines'].size).to eq(10)

      end
    end

    describe 'update orders ~>' do

      it 'it updates order to on process' do
        order = create_order user

        post "/orders/#{order.id}/update_status", params: {status: "1"}

        expect(response).to have_http_status(:ok)
        expect(payload).to_not be_empty
        expect(payload['status']).to eq("on_process")
      end

      it 'order must be pending for updates status on process' do

        order = create_order user, true, 1

        post "/orders/#{order.id}/update_status", params: {status: "1"}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(payload).to_not be_empty
      end
    end
  end
end


def create_invalid_card(openpay_instance, card_number, address, customer_id)

  @cards = openpay_instance.create(:cards)
      
  req_payload = {
    :holder_name => "Juan Perez Ramirez",
    :card_number => card_number,
    :cvv2 => "110",
    :expiration_month => "12",
    :expiration_year => "25",
    :device_session_id => "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f",
    :address => {
      :line1 => address.line,
      :line2 => nil,
      :line3 => nil,
      :state => address.state,
      :city => address.city,
      :postal_code => address.zip_code,
      :country_code => "MX"
    }
  }

  begin
    invalid_card = @cards.create(req_payload, customer_id)
  rescue => exception
    binding.pry
  end

  invalid_card
end