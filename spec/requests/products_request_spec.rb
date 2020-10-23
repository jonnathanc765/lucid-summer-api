require 'rails_helper'

RSpec.describe "Products ~>", type: :request do
  let(:user) do
      u = create(:user)
      u.add_role "super-admin"
      u
  end

  sign_in(:user)

  describe "GET /products ~>" do
    before { get '/products' }

    it "should return status code 200" do
      expect(response).to have_http_status(:ok)
      expect(payload).to_not be_nil
    end

    describe "with data in DB ~>" do

      it "should return a complete list of products" do
        products = create_list(:product, 9)
        get "/products"
        expect(payload.size).to eq(products.size)
        expect(payload).to_not be_empty
        expect(response).to have_http_status(:ok)
      end

      it 'user can retrieve products by category scope' do
        category = create(:category)
        category2 = create(:category)
        products = create_list(:product, 5, category_id: category.id)
        products = create_list(:product, 5, category_id: category2.id)

        get "/products?categories[]=1"
        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(5)

      end

      it 'user can retrieve products by name scope' do
        
        product = create(:product, name: "This is the product name")
        create_list(:product, 10)

        get "/products?name=This is the product name"

        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(1)

      end

      it 'user can retrieve products with its category' do 

        category = create(:category)
        product = create(:product, name: "This is the product name", category_id: category.id)

        create_list(:product, 19)

        get "/products"

        expect(response).to have_http_status(:ok)
        expect(payload.size).to eq(20)
        expect(payload[19]['category']).to_not be_nil
        expect(payload[19]['category']['name']).to eq(category.name)
      end

      it 'products its retieving in desc created order' do
        product = create(:product, name: "This is the product name")
        create_list(:product, 9)

        get "/products"

        expect(response).to have_http_status(:ok)
        expect(payload[9]['id']).to eq(product.id)
      end

    end
  end

  describe "it show a product details" do
    let!(:product) { create(:product) }

    it "response status 200 and show the data" do
      get "/products/#{product.id}"

      expect(response).to have_http_status(:ok)
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(product.id)
    end

    it "return 404 status for not existing records" do
      get "/products/653546"
      expect(response).to have_http_status(404)
    end

    it 'return a product with its images' do
      
      attached = fixture_file_upload('spec/storage/Products/apple.png', 'image/png')

      product.images.attach(attached)

      get "/products/#{product.id}"
      expect(response).to have_http_status(:ok)
      expect(payload["images"]).to_not be_nil
      expect(payload["images"].size).to eq(1)

    end
  end

  describe "POST /products/:id" do
    let(:category) { create(:category) }

    it "it save with correct data" do
      req_payload = { name: "Tomatoes", retail_price: 10, wholesale_price: 8.5, promotion_price: 9.5, approximate_weight_per_piece: 250, category_id: category.id }
      post "/products", params: req_payload

      expect(response).to have_http_status(201)
      expect(payload).to_not be_empty
      expect(payload["id"]).to_not be_nil
      expect(payload["category_id"]).to eq(category.id)
    end
  end

  describe "PUT /products/:id" do
    let(:product) { create(:product) }

    it "it updates a existing product" do
      req_payload = { name: "Tomatoes", retail_price: 10, wholesale_price: 8.5, promotion_price: 9.5, approximate_weight_per_piece: 250 }
      put "/products/#{product.id}", params: req_payload

      expect(response).to have_http_status(200)
      expect(payload).to_not be_empty
      expect(payload["id"]).to_not be_nil
      expect(payload['name']).to eq("Tomatoes")
      expect(Product.all.size).to eq(1)
    end
  end

  describe "DELETE /products/:id" do
    let(:product) { create(:product) }

    it "destroy a product" do
      delete "/products/#{product.id}"

      expect(response).to have_http_status(200)
      expect(Product.count).to eq(0)
    end
  end
end
