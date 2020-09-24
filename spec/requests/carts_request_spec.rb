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

            get "/carts/#{user.id}"

            expect(response).to have_http_status(:ok) 
            expect(Cart.all.count).to eq(1)
            expect(payload).to_not be_empty
            
        end

        

        it "a user can have just one cart" do

            Cart.create(user_id: user.id)

            get "/carts/#{user.id}"

            expect(response).to have_http_status(:ok) 
            expect(payload).to_not be_empty 
            expect(Cart.count).to eq(1)
            
        end
        
        
        
    end
    

end