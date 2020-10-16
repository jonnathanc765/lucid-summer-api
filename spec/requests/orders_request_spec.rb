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

    let(:user) do
      user = create(:user, first_name: "Client User")
      user.add_role 'client'
      user.save
      user
    end

    sign_in(:user)

    describe "GET /orders ~>" do

      it "Users can see its orders" do
        orders = create_list(:order, 10, user_id: user.id)
        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(10)
        expect(payload[0]['id']).to eq(orders[0]['id'])
      end

      it 'users only can see only its orders' do
        create_list(:order, 10)
        orders = create_list(:order, 4, user_id: user.id)
        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(4)
        expect(payload[0]['id']).to eq(orders[0]['id'])
      end

      it 'admin and super admin can see all orders' do

        create_list(:order, 10)
        orders = create_list(:order, 4, user_id: user.id)

        user.remove_role 'client'
        user.add_role 'admin'

        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(14)

        user.remove_role 'admin'
        user.add_role 'super-admin'

        get "/orders"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(14)


      end

    end

    describe 'POST /orders ~>' do
      it 'client can generate a order' do

        cart = create_cart user

        address = create(:address, user_id: user.id)

        post "/orders", params: {address_id: address.id}

        expect(response).to have_http_status(:created)
        expect(payload).to_not be_empty
        expect(payload["status"]).to eq("pending")
        expect(payload["address"]).to eq(address.address)
        expect(payload['order_lines'].size).to eq(10)
        expect(CartLine.all.size).to eq(0)

      end
      it 'address is required for generate a order' do

        cart = create_cart user

        address = create(:address, user_id: user.id)

        post "/orders"

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.all.size).to eq(0)
      end
      it 'must exists cart lines of current user' do

        cart = create_cart user, false

        address = create(:address, user_id: user.id)

        post "/orders", params: {address_id: address.id}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.all.size).to eq(0)

      end
      it 'current user must be owner of id address sent it' do

        cart = create_cart user

        addresses = create_list(:address, 4)

        address = create(:address, user_id: user.id)

        post "/orders", params: {address_id: addresses[2].id}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(Order.all.size).to eq(0)
        expect(OrderLine.all.size).to eq(0)

      end

      it 'address must exists' do

        cart = create_cart user

        address = create(:address, user_id: user.id)

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
