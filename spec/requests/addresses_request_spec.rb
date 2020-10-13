require 'rails_helper'

RSpec.describe "Addresses ~>", type: :request do

    describe 'guest users ~>' do

        it 'return a unauthenticared user status code' do

            get "/addresses"
            expect(response).to have_http_status(401)
            
            post "/addresses"
            expect(response).to have_http_status(401)
        end

      
    end

    describe 'Logged in users ~>' do

        let(:user) do 
            user = create(:user, first_name: 'Client', last_name: 'User')
            user.add_role 'client'
            user
        end

        sign_in(:user)
      
        describe 'GET /addresses ~>' do
    
            it 'return a success status code' do
    
                get "/addresses"
    
                expect(response).to have_http_status(:ok)
                expect(payload).to be_empty
                
            end
            
            it 'return a list of addresses' do
                addresses = create_list(:address, 10, user_id: user.id)

                get '/addresses'
                expect(response).to have_http_status(:ok)
                expect(payload.size).to eq(10)
                expect(payload[0]['id']).to eq(addresses[0]['id'])

            end

            it 'current user only can see its addresses' do 

                create_list(:address, 10)
                addresses = create_list(:address, 2, user: user, address: "Address test for current user")
                get "/addresses"

                expect(response).to have_http_status(:ok)
                expect(payload.size).to eq(2)
                expect(payload[0]['address']).to eq("Address test for current user")
                expect(payload[1]['address']).to eq("Address test for current user")

            end
        end

        describe 'POST /addresses ~>' do
          it 'save correctly in DB' do
                
            req_payload = { address: 'Test address', city: 'Test city', state: 'Test state', country: 'Test country' }

            post '/addresses', params: req_payload

            expect(response).to have_http_status(:created)
            expect(payload['address']).to eq('Test address')
            expect(payload['city']).to eq('Test city')
            expect(payload['state']).to eq('Test state')
            expect(payload['country']).to eq('Test country')

          end
        end

        describe 'PUT /addresses/:id ~>' do
          it 'address can be update' do

            address = create(:address, user_id: user.id)
            req_payload = { address: 'Test address', city: 'Test city', state: 'Test state', country: 'Test country' }

            put "/addresses//#{address.id}", params: req_payload

            expect(payload['address']).to eq('Test address')
            expect(payload['city']).to eq('Test city')
            expect(payload['state']).to eq('Test state')
            expect(payload['country']).to eq('Test country')

          end

          it 'can update only its addresses' do

            addresses = create_list(:address, 4)
            create(:address, user_id: user.id, address: 'Test address')

            req_payload = { address: 'Test address', city: 'Test city', state: 'Test state', country: 'Test country' }

            put "/addresses//#{addresses[0].id}", params: req_payload

            expect(response).to have_http_status(:forbidden)
            no_updated_address = Address.find(addresses[0].id)

            expect(no_updated_address.address).to eq(addresses[0].address)
            expect(no_updated_address.city).to eq(addresses[0].city)
            expect(no_updated_address.state).to eq(addresses[0].state)
            expect(no_updated_address.country).to eq(addresses[0].country)

          end

        end

        describe 'DELETE /addresses/:id ~>' do
          it 'user can delete addresses' do

            address = create(:address, user_id: user.id)
            delete "/addresses//#{address.id}"
            expect(response).to have_http_status(:ok)
            expect(payload).to_not be_empty
            expect(payload['message']).to eq("Record deleted")

          end

          it 'user can delete only its addresses' do

            another_address = create(:address)

            address = create(:address, user_id: user.id)

            delete "/addresses//#{another_address.id}"
            expect(response).to have_http_status(:forbidden)
            expect(Address.all.size).to eq(2)

          end
        end

        describe 'GET /addresses/:id ~>' do
            it 'user can see addresses' do
  
              address = create(:address, user_id: user.id)
              get "/addresses//#{address.id}"
              expect(response).to have_http_status(:ok)
              expect(payload).to_not be_empty
              expect(payload['id']).to eq(address.id)
              expect(payload['address']).to eq(address.address)
  
            end
  
            it 'user can see only its addresses' do
  
              another_address = create(:address)
  
              address = create(:address, user_id: user.id)
  
              get "/addresses//#{another_address.id}"
              expect(response).to have_http_status(:forbidden)
  
            end
          end

    end


end
