require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:user) do
    u = create(:user)
    u.add_role "super-admin"
    u
  end

  sign_in(:user)

  describe "GET /categories request" do
    describe "witout data in DB" do
      it "it return a success code for categories list" do
        get "/categories"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(0)
        expect(payload).to be_empty
      end
    end

    describe "with data in DB" do
      let!(:categories) { create_list(:category, 5) }

      it "it return a list of caegories" do
        get "/categories"

        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(5)
        expect(payload).to_not be_empty
      end
    end
  end

  describe "POST /categories" do
    describe "create a category with correct data" do
      it 'save correctly' do
        # user.add_role "super-admin"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        post "/categories", params: req_payload
        expect(response).to have_http_status(:created)
        expect(payload["id"]).to_not be_nil
        expect(payload["name"]).to eq("Herb")
        expect(payload["description"]).to eq("Some herbs")
        expect(payload["color"]).to eq("#4F5897")
      end
    end

    describe "without correctly data" do
      it "dont save the wrong data" do
        req_payload = {name: "", description: "Some herbs"}
        post "/categories", params: req_payload
        expect(response).to have_http_status(422)

        expect(payload["id"]).to be_nil
        expect(payload["error"]).to_not be_empty
      end
    end

    describe "parent category" do 
      let(:parent_category) { create(:category) }
      it 'can create a category with parent category' do

        parent_category = create(:category)

        req_payload = {name: "Child category", description: "Some herbs", parent_category: parent_category.id}

        post "/categories", params: req_payload
        expect(response).to have_http_status(:created)
        expect(payload).to_not be_empty 
        expect(payload["parent_category"]['id']).to eq(parent_category.id)
        expect(Category.all.size).to eq(2)      

      end

      it 'parent category must exist' do
        
        req_payload = {name: "Child category", description: "Some herbs", parent_category: 8574}

        post "/categories", params: req_payload

        expect(response).to have_http_status(:unprocessable_entity)
      end

    end

    describe "Permissions" do 
      it "Super admin can create categories" do

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        post "/categories", params: req_payload
        expect(response).to have_http_status(:created)
        expect(Category.all.size).to eq(1)

      end

      it "Super admin can create categories" do

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        post "/categories", params: req_payload
        expect(response).to have_http_status(:created)
        expect(Category.all.size).to eq(1)

      end

      it "Employee can't create categories" do
        user.remove_role "super-admin"
        user.add_role "employee"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        post "/categories", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(0)

      end
      it "dispatcher can't create categories" do
        user.remove_role "super-admin"
        user.add_role "dispatcher"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        post "/categories", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(0)
      end
      it "Delivery man can't create categories" do
        user.remove_role "super-admin"
        user.add_role "delivery-man"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        post "/categories", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(0)
      end
      it "client can create category" do
        user.remove_role "super-admin"
        user.add_role "client"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        post "/categories", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(0)
      end
    end
  end

  describe "PUT  /categories/{id}" do
    let!(:category) { create(:category) }

    it "it update a existing category" do
      req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
      put "/categories/#{category.id}", params: req_payload

      expect(response).to have_http_status(:ok)
      expect(payload["id"]).to_not be_nil
      expect(payload["id"]).to eq(category.id)
      expect(payload["name"]).to eq("Herb")
      expect(payload["description"]).to eq("Some herbs")
      expect(payload["color"]).to eq("#4F5897")
    end

    describe 'parent_category' do
      it 'parent category cant be itself' do
        c = create(:category)
        req_payload = {name: "Herb v2", description: "Some herbs v2", color: '#000000', parent_category: c.id}
        put "/categories/#{c.id}", params: req_payload
        expect(response).to have_http_status(:unprocessable_entity)
        expect(payload["id"]).to be_nil
      end
    end

    describe "Permissions" do 
      it "Super admin can update categories" do
        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        put "/categories/#{category.id}", params: req_payload
        expect(response).to have_http_status(:ok)
        expect(Category.all.size).to eq(1)
        fresh_category = Category.first
        expect(fresh_category.id).to eq(category.id)
        expect(fresh_category.name).to eq("Herb")
        expect(fresh_category.description).to eq("Some herbs")

      end

      it "Super admin can update categories" do

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        put "/categories/#{category.id}", params: req_payload
        expect(response).to have_http_status(:ok)
        expect(Category.all.size).to eq(1)
        fresh_category = Category.first
        expect(fresh_category.id).to eq(category.id)
        expect(fresh_category.name).to eq("Herb")
        expect(fresh_category.description).to eq("Some herbs")

      end

      it "Employee can't update categories" do
        user.remove_role "super-admin"
        user.add_role "employee"
        
        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        put "/categories/#{category.id}", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(1)

      end
      it "dispatcher can't update categories" do
        user.remove_role "super-admin"
        user.add_role "dispatcher"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        put "/categories/#{category.id}", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(1)
      end
      it "Delivery man can't update categories" do
        user.remove_role "super-admin"
        user.add_role "delivery-man"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        put "/categories/#{category.id}", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(1)
      end
      it "client can't update category" do
        user.remove_role "super-admin"
        user.add_role "client"

        req_payload = {name: "Herb", description: "Some herbs", color: '#4F5897'}
        put "/categories/#{category.id}", params: req_payload
        expect(response).to have_http_status(:forbidden)
        expect(Category.all.size).to eq(1)
      end
    end

  end

  describe "DELETE /products/:id ~>" do
    describe "it deletes a category" do
      let!(:category) { create(:category) }

      it "destroy category" do
        delete "/categories/#{category.id}"
        expect(response).to have_http_status(200)
        expect(payload).to_not be_empty
        expect(Category.count).to eq(0)
      end
    end

    describe "it set on null category_id field to products when a category is deleted" do
      let!(:category) { create(:category) }
      let!(:product) { create(:product) }

      it "destroy category and set null category_id on null" do
        product.category = category
        product.save

        expect(product.reload.category).to_not be_nil

        delete "/categories/#{category.id}"

        expect(response).to have_http_status(200)
        expect(payload).to_not be_empty
        expect(product.reload.category).to be_nil
      end
    end

    

  end
end
