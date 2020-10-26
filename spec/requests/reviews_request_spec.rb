require 'rails_helper'

RSpec.describe "Reviews ~>", type: :request do

  let(:user) do
    u = create(:user)
    u.add_role "client"
    u
  end

  describe 'Guest user ~>' do

    it 'user must be logged in for make a review' do

        order = create_order user
        
        req_payload = { reviewable_type: 'order', id: order.id, title: "review title test", description: "review description test", stars: "3" }

        user.remove_role 'client'
        user.add_role 'employee'
    
        post "/reviews", params: req_payload 

        expect(response).to have_http_status(401)
        expect(Review.all.size).to eq(0)
        
      end

      describe 'GET /review/:id' do
        it 'every user can see review' do
            review = create(:review)
    
            get "/reviews/#{review.id}"

            expect(response).to have_http_status(:ok)
            expect(payload).to_not be_empty
            expect(payload["title"]).to_not be_nil
            expect(payload["description"]).to_not be_nil
            expect(payload["stars"]).to_not be_nil
    
            
        end
      end

  end

  describe 'logged in users' do

    sign_in(:user)

    let(:delivery_man) do
      u = create(:user)
      u.add_role "delivery-man"
      u
    end

    describe 'GET /reviews' do
      it 'it retrieve a list of reviews' do

        create_list(:review, 20)

        get "/reviews"

        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(20)
      end
    end

    describe 'DELETE /reviews/:id' do

      let(:admin) do
        u = create(:user)
        u.add_role "admin"
        u
      end
      sign_in(:admin)

      it 'it delete a review' do

        review = create(:review)
        delete "/reviews/#{review.id}"
        expect(response).to have_http_status(:ok)
        expect(Review.all.size).to eq(0)
        
      end
    end

    describe 'POST /reviews make reviews ~>' do
        
      it 'clients can make a review to delivery man' do
        order = create_order user
        
        req_payload = { reviewable_type: 'user', id: user.id, title: "review title test", description: "review description test", stars: "3" }
    
        post "/reviews", params: req_payload 

        expect(response).to have_http_status(:created)
        expect(payload).to_not be_empty
        expect(payload['id']).to_not be_nil
        expect(payload['title']).to eq("review title test")
        expect(payload['description']).to eq("review description test")
        expect(payload['stars']).to eq(3)
        expect(Review.all.size).to eq(1)
        
      end

      it 'user to make review must exists' do
        order = create_order user
        
        req_payload = { reviewable_type: 'user', id: 352, title: "review title test", description: "review description test", stars: "3" }
    
        post "/reviews", params: req_payload 

        expect(response).to have_http_status(:unprocessable_entity)
        
      end

      it 'model specified must be valida (user or order)' do
        order = create_order user
        
        req_payload = { reviewable_type: 'use', id: user.id, title: "review title test", description: "review description test", stars: "3" }
    
        post "/reviews", params: req_payload 

        expect(response).to have_http_status(:unprocessable_entity)
        
      end

      it "order can be reviewed for a client user" do 

        order = create_order user
        
        req_payload = { reviewable_type: 'order', id: user.id, title: "review title test", description: "review description test", stars: "4" }
    
        post "/reviews", params: req_payload 

        expect(response).to have_http_status(:created)
        expect(payload).to_not be_empty
        expect(payload['id']).to_not be_nil
        expect(payload['title']).to eq("review title test")
        expect(payload['description']).to eq("review description test")
        expect(payload['stars']).to eq(4)
        expect(Review.all.size).to eq(1)

      end

      it 'order to make review must exists' do
        order = create_order user
        
        req_payload = { reviewable_type: 'order', id: 352, title: "review title test", description: "review description test", stars: "3" }
    
        post "/reviews", params: req_payload 

        expect(response).to have_http_status(:unprocessable_entity)
        
      end

      it 'only clients can make reviews' do
        order = create_order user
        
        req_payload = { reviewable_type: 'order', id: order.id, title: "review title test", description: "review description test", stars: "3" }

        user.remove_role 'client'
        user.add_role 'employee'
    
        post "/reviews", params: req_payload 

        expect(response).to have_http_status(:forbidden)
        expect(Review.all.size).to eq(0)
        
      end

    end
  end

  

end

def create_order(user, with_lines = true)
  
  order = create(:order, user_id: user.id)
    
  if with_lines 
    products = create_list(:product, 10)
    products.each do |p|
      order.order_lines.create(product_id: p['id'], quantity: 2, price: p['retail_price'], unit_type: 'Unit')
    end
  end
    
  order
end
  