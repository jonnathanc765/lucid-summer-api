require 'rails_helper'

RSpec.describe "Addresses", type: :request do

    describe 'guest users' do

        it 'return a success status code' do

            get "/addresses"
            expect(response).to have_http_status(401)
            
        end
      
    end

    describe 'Logged in users' do

        let(:user) do 
            user = create(:user)
            user.add_role 'client'
            user
        end

        sign_in(:user)
      
        describe 'GET /addresses' do
    
            it 'return a success status code' do
    
                get "/addresses"
    
                expect(response).to have_http_status(:ok)
                expect(payload).to be_empty
                
            end
    
        end

    end


end
