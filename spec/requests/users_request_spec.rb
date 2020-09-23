require 'rails_helper'

RSpec.describe "Users", type: :request do

    describe "GET /users" do 

        before { get '/users' }

        describe "without data in DB" do 
            it "should return OK" do
                expect(payload).to be_empty  
                expect(payload)
            end
    
            it "should return status code 200" do
                expect(response).to have_http_status(:ok)
            end
        end

        describe "with data in DB" do

            describe "GET to /users" do
                let!(:users) { create_list(:user, 10) }

                it "should return a list of users" do
                    get '/users'
                    expect(payload.size).to eq(users.size)
                    expect(response).to have_http_status(:ok)
                end

            end

            describe "GET to /users/{id}" do
                let!(:user) { create(:user) }
                
                it "should return a single user by id param" do
                    get "/users/#{user.id}"
                    expect(payload["id"]).to eq(user.id)
                    expect(response).to have_http_status(:ok)
                end

            end
            
        end

    end

    describe "POST /users (to create new user)" do
        
        describe "create a user" do

            let!(:user) { create(:user) }
            it "with valid data it success" do
                req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
                post "/users", :params => req_payload
                expect(payload).to_not be_empty
                expect(payload["id"]).to_not be_nil
                expect(response).to have_http_status(:created)
            end

            let!(:user) { create(:user) }
            it "with invalid data should return a error message" do
                req_payload = { first_name: "", last_name: "", email: "invalid-email", phone: "", password: "" }
                post "/users", :params => req_payload
                expect(payload).to_not be_empty 
                expect(payload["error"]).to_not be_empty 
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
        
    end

    describe "PUT /users/:id (to update a existing user)" do
        
        
        describe "update a existing user" do

            let!(:user) { create(:user) }

            it "with valid data it success" do
                
                req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
                put "/users/#{user.id}", params: req_payload
                expect(payload).to_not be_nil 
                expect(payload["id"]).to eq(user.id)
                expect(response).to have_http_status(:ok)
            end

            let!(:user) { create(:user) }
            
            it "with invalid data should return a error message" do
                req_payload = { first_name: "", last_name: "", email: "invalid-email", phone: "" }
                put "/users/#{user.id}", params: req_payload
                expect(payload).to_not be_empty 
                expect(payload["error"]).to_not be_empty 
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end

    end

end
