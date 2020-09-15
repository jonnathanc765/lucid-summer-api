require 'rails_helper'

RSpec.describe "Users", type: :request do
    describe "GET /users" do 

        before { get '/users' }

        describe "without data in DB" do 
            it "should return OK" do
                payload = JSON.parse(response.body)
                expect(payload).to be_empty  
                expect(payload)
            end
    
            it "should return status code 200" do
                expect(response).to have_http_status(200)
            end
        end

        describe "with data in DB" do

            describe "GET to /users" do
                let!(:users) { create_list(:user, 10) }

                it "should return a list of users" do
                    get '/users'
                    payload = JSON.parse(response.body)
                    expect(payload.size).to eq(users.size)
                    expect(response).to have_http_status(200)
                end

            end

            describe "GET to /users/{id}" do
                let!(:user) { create(:user) }
                
                it "should return a single user by id param" do
                    get "/users/#{user.id}"
                    payload = JSON.parse(response.body)
                    expect(payload["id"]).to eq(user.id)
                    expect(response).to have_http_status(200)
                end

            end
            
        end

    end
end
