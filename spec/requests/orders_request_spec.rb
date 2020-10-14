require 'rails_helper'

RSpec.describe "Orders", type: :request do

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

  end

end
