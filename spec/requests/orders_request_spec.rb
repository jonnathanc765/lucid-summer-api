require 'rails_helper'

RSpec.describe "Orders ~>", type: :request do

  describe 'Guest users ~>' do
    describe "GET /orders" do
      it 'users must be logged in for see its orders' do

        get "/orders"
        expect(response).to have_http_status(401)
        
      end
    end

    
  end

  describe 'Logged in users ~>' do

    let(:user) do 
      user = create(:user)
      user.add_role 'client'
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
        expect(payload['order_lines'].size).to eq(2)
        expect(CartLine.all.size).to eq(0)

      end      
    end
  end
end

def create_cart(user, with_lines = true)
  
  cart = Cart.create(user_id: user.id)
  
  if with_lines 
    products = create_list(:product, 2)
    cart.cart_lines.create(product_id: products[0]['id'], quantity: 2)
    cart.cart_lines.create(product_id: products[1]['id'], quantity: 1)
  end
  
  cart
end
