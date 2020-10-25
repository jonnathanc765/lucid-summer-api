require 'rails_helper'

RSpec.describe "Users ~>", type: :request do
  
  describe 'Guest users ~>' do
    it 'users must be authenticated for access to list' do
      get "/users"
      expect(response).to have_http_status(401)
    end
  end

  describe 'Authenticated users ~>' do

    let(:user) do 
      u = create(:user)
      u.add_role "admin"
      u
    end
    sign_in(:user)

    describe "GET /users ~>" do
      
      describe "without data in DB" do
        it "should return OK" do
          get '/users'
          expect(payload).to_not be_empty
          expect(payload)
        end
  
        it "should return status code 200" do
          get '/users'
          expect(response).to have_http_status(:ok)
        end
      end
  
      describe "with data in DB" do
        describe "GET to /users" do
          let!(:users) { create_list(:user, 9) }
            
          it "should return a list of users" do
            get '/users'
            expect(response).to have_http_status(:ok)
            expect(payload.size).to eq(10)
          end
          
        end
  
        describe "GET to /users/{id}" do

          let!(:new_user) { create(:user) }
  
          it "should return a single user by id param" do
            get "/users/#{new_user.id}"
            expect(response).to have_http_status(:ok)
            expect(payload["id"]).to eq(new_user.id)
          end
        end
      end
    end
  
    describe "POST /users (to create new user) ~>" do
      describe "create a user" do
  
        it "with valid data it success" do
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
          post "/users", :params => req_payload
          expect(response).to have_http_status(:created)
          expect(payload).to_not be_empty
          expect(payload["id"]).to_not be_nil
        end
  
        it "with invalid data should return a error message" do
          req_payload = { first_name: "", last_name: "", email: "invalid-email", phone: "", password: "" }
          post "/users", :params => req_payload
          expect(response).to have_http_status(:unprocessable_entity)
          expect(payload).to_not be_empty
          expect(payload["error"]).to_not be_empty
        end

        it 'admin can asign role when creates a user' do
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", role: 'employee' }
          post "/users", :params => req_payload
          created_user = User.last
          expect(response).to have_http_status(:created)
          expect(created_user.has_role? "employee").to eq(true)
        end
        it 'only admin can create anothers admins' do
          user.remove_role "admin"
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", role: 'admin' }
          post "/users", :params => req_payload
          expect(response).to have_http_status(:unprocessable_entity)
          expect(payload['error']).to_not be_empty
        end
      end
    end
  
    describe "PUT /users/:id (to update a existing user) ~>" do
      describe "update a existing user" do

        let!(:new_user) { create(:user) }
  
        it "with valid data it success" do
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
          put "/users/#{new_user.id}", params: req_payload
          expect(response).to have_http_status(:ok)
          expect(payload).to_not be_nil
          expect(payload["id"]).to eq(new_user.id)
        end
  
        let!(:new_user) { create(:user) }
  
        it "with invalid data should return a error message" do
          req_payload = { first_name: "", last_name: "", email: "invalid-email", phone: "" }
          put "/users/#{new_user.id}", params: req_payload
          expect(response).to have_http_status(:unprocessable_entity)
          expect(payload).to_not be_empty
          expect(payload["error"]).to_not be_empty
        end
      end
    end

    describe 'permissions ~>' do
      let(:no_admin_user) do 
        u = create(:user)
        u.add_role "dispatcher"
        u.add_role "employee"
        u.add_role "delivery-man"
        u.add_role "client"
        u
      end
      sign_in(:no_admin_user)

      it 'no admin user cannot retrieve list of users' do
        get "/users"
        expect(response).to have_http_status(403)
      end
      it 'no admin user cannot store new users' do
        post "/users"
        expect(response).to have_http_status(403)
      end
      it 'no admin user cannot retrieve list of users' do
        put "/users/1"
        expect(response).to have_http_status(403)
      end

    end
  end
end
