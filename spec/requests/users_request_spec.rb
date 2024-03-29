require 'rails_helper'

RSpec.describe "Users ~>", type: :request do

  let(:openpay) {
    OpenpayApi.new("mihqpo64jxhksuoohivz","sk_f6aafbacebd64882a224446b1331ef3c") 
  }

  let(:customers) {
    openpay.create(:customers)
  }


  describe 'Guest users ~>' do

    it 'users must be authenticated for access to list' do
      get "/users"
      expect(response).to have_http_status(403)
    end

    it 'guest users can register himlself' do
      req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
      post "/users", :params => req_payload
      expect(response).to have_http_status(:created)
      expect(payload).to_not be_empty
      expect(payload["id"]).to_not be_nil
      expect(User.all.size).to eq(1)
    end

    it 'users can take registered emails' do
      test_user = create(:user, email: "jose@perez.com")
      req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
      post "/users", :params => req_payload
      expect(response).to have_http_status(:unprocessable_entity)
      expect(payload["id"]).to be_nil
      expect(User.all.size).to eq(1)
      expect(User.first.phone).to eq(test_user.phone)
    end

    it 'can create with employee role' do
      req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["employee"] }
      post "/users", :params => req_payload
      expect(response).to have_http_status(:forbidden)
      expect(payload).to_not be_empty
      expect(User.all.size).to eq(0)
    end

    it 'can create with dispatcher role' do
      req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["dispatcher"] }
      post "/users", :params => req_payload
      expect(response).to have_http_status(:forbidden)
      expect(payload).to_not be_empty
      expect(User.all.size).to eq(0)
    end

    it 'can create with delivery-man role' do
      req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["delivery-man"] }
      post "/users", :params => req_payload
      expect(response).to have_http_status(:forbidden)
      expect(payload).to_not be_empty
      expect(User.all.size).to eq(0)
    end

  end

  describe 'Authenticated users ~>' do


    let(:test_user_token) do 
      u = create(:user)
      u.add_role "dispatcher"
      u 
    end

    it 'users can login with api' do
      post "/auth/sign_in", :params => { email: test_user_token.email, password: "password" }
      expect(response).to have_http_status(:ok)
      expect(payload).to_not be_empty 
      expect(payload["roles"]).to_not be_nil 
      expect(payload["roles"][1]["name"]).to_not be_nil 
      expect(payload["roles"][1]["name"]).to eq("dispatcher") 
    end

    let(:test_user_token2) do 
      u = create(:user)
      u.add_role "dispatcher"
      u 
    end

    sign_in(:test_user_token2)

    it 'users can validate their token with api' do
      get "/auth/validate_token", :params => { email: test_user_token2.email, password: "password" }
      expect(response).to have_http_status(:ok)
      expect(payload).to_not be_empty 
      expect(payload["roles"]).to_not be_nil
      expect(payload["roles"][1]["name"]).to_not be_nil 
      expect(payload["roles"][1]["name"]).to eq("dispatcher") 
    end


    describe 'Admins users' do
      
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
  
      describe 'DELETE /users/:id' do
  
        it 'admins can destroy users' do
  
          user = create(:user)
  
          delete "/users/#{user.id}"
  
          expect(response).to have_http_status(:ok)
          expect(payload['message']).to eq('Record deleted!') 
          expect(User.all.size).to eq(1)
          
        end
  
      end
  
      describe "POST /users (to create new user) ~>" do
        describe "create a user ~>" do
  
          it "with valid data it success" do
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", rfc: "212312" }
            post "/users", :params => req_payload
            expect(response).to have_http_status(:created)
            expect(payload).to_not be_empty
            expect(payload["id"]).to_not be_nil
            expect(payload["rfc"]).to eq("212312")
          end
  
          it "with invalid data should return a error message" do
            req_payload = { first_name: "", last_name: "", email: "invalid-email", phone: "", password: "" }
            post "/users", :params => req_payload
            expect(response).to have_http_status(:unprocessable_entity)
            expect(payload).to_not be_empty
            expect(payload["error"]).to_not be_empty
          end
  
          it 'admin can asign role when creates a user' do
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ['employee'] }
            post "/users", :params => req_payload
            created_user = User.last
            expect(response).to have_http_status(:created)
            expect(created_user.has_role? "employee").to eq(true)
          end
          it 'only admin can create anothers admins' do
            user.remove_role "admin"
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ['admin'] }
            post "/users", :params => req_payload
            expect(response).to have_http_status(:forbidden)
            expect(payload['error']).to_not be_empty
          end
          it 'only super admin can create another super admins' do
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["super-admin"] }
            post "/users", params: req_payload
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
  
      describe "PUT /users/:id (to update a existing user) ~>" do
        describe "update a existing user" do
  
          let!(:new_user) { create(:user) }
  
          it "with valid data it success" do
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", rfc: "212312" }
            put "/users/#{new_user.id}", params: req_payload
            expect(response).to have_http_status(:ok)
            expect(payload).to_not be_nil
            expect(payload["id"]).to eq(new_user.id)
            expect(payload["rfc"]).to eq("212312")
          end
  
          let!(:new_user) { create(:user) }
  
          it "with invalid data should return a error message" do
            req_payload = { first_name: "", last_name: "", email: "invalid-email", phone: "" }
            put "/users/#{new_user.id}", params: req_payload
            expect(response).to have_http_status(:unprocessable_entity)
            expect(payload).to_not be_empty
            expect(payload["error"]).to_not be_empty
          end
  
          it 'users can change of role' do
            test_user = create(:user)
  
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["admin", "delivery-man"]}
            put "/users/#{test_user.id}", params: req_payload
  
            test_user.roles.reload
  
            expect(response).to have_http_status(:ok)
            expect(test_user.roles.size).to eq(2)
            expect(test_user.has_all_roles? "delivery-man", "admin").to eq(true)
  
          end
        end
      end
  
      describe 'permissions ~>' do
  
        let(:no_admin_user) do
          u = create(:user, first_name: 'test user')
          u.add_role "dispatcher"
          u.add_role "employee"
          u.add_role "delivery-man"
          u
        end
  
        sign_in(:no_admin_user)
  
        it 'no admin user cannot retrieve list of users' do
          get "/users"
          expect(response).to have_http_status(:forbidden)
        end
  
        it 'no admin user cannot update any user' do
          user = create(:user)
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
          put "/users/#{user.id}", params: req_payload
          expect(response).to have_http_status(:forbidden)
        end
  
        it 'no admin user cannot update any user' do
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
          put "/users/#{user.id}", params: req_payload
          expect(response).to have_http_status(:forbidden)
        end
  
        it 'no admin users cannot update anothers users' do
          no_admin_user.remove_role "client"
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["client"] }
          put "/users/#{no_admin_user.id}", params: req_payload
          expect(response).to have_http_status(:forbidden)
        end
  
        it 'Client can update his own profile' do
  
          no_admin_user.add_role "client"
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
          put "/users/#{no_admin_user.id}", params: req_payload
          expect(response).to have_http_status(:ok)
          expect(no_admin_user.has_role? "dispatcher").to eq(true)
          expect(no_admin_user.has_role? "employee").to eq(true)
          expect(no_admin_user.has_role? "delivery-man").to eq(true)
  
        end
  
        it 'Client just can update his own profile and no others' do
          no_admin_user.add_role "client"
          test_user = create(:user)
          test_user.add_role "client"
          req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
          put "/users/#{test_user.id}", params: req_payload
          expect(response).to have_http_status(:forbidden)
        end
  
  
        describe 'Super admin ~>' do
          let(:super_admin_user) do
            u = create(:user)
            u.add_role "super-admin"
            u
          end
          sign_in(:super_admin_user)
          it 'super admin can create another super admin' do
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["super-admin"] }
            post "/users", params: req_payload
            expect(response).to have_http_status(:created)
            expect(User.last.has_role? "super-admin").to eq(true)
          end
          it 'super admin can create another admin' do
            req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password", roles: ["admin"] }
            post "/users", params: req_payload
            expect(response).to have_http_status(:created)
            expect(User.last.has_role? "admin").to eq(true)
          end
        end
  
      end
    end


  end
end
