require 'rails_helper'

RSpec.describe "Cart", type: :request do
    
    let(:user) do
        u = create(:user)
        u.add_role "client"
        u 
    end 

    sign_in(:user)

    describe "Initial cart" do

        it "a client can generate a cart" do

            get "/cart"

            expect(response).to have_http_status(:ok) 
            expect(Cart.all.count).to eq(1)
            expect(payload).to_not be_empty
            
        end

        it "a user can have just one cart" do

            Cart.create(user_id: user.id)

            get "/cart"

            expect(response).to have_http_status(:ok) 
            expect(payload).to_not be_empty 
            expect(Cart.count).to eq(1)
            
        end

        let!(:product) { create(:product, name: "Apple") }

        it "a cart can be retrieve with cart lines" do
            cart = Cart.create(user_id: user.id)
            cart.cart_lines.create(quantity:10, product_id: product.id)

            get "/cart"
            
            expect(response).to have_http_status(:ok) 
            expect(payload).to_not be_empty 
            expect(payload["id"]).to_not be_nil
            expect(payload["cart_lines"][0]["product_id"]).to eq(product.id)

        end
        
    end

end