require 'rails_helper'

RSpec.describe "Products", type: :request do

    let(:user) do
        u = create(:user)
        u.add_role "super-admin"
        u 
    end
    sign_in(:user)

    describe "GET /products" do
        before { get '/products' }

        it "should return status code 200" do

            expect(response).to have_http_status(:ok)
            expect(payload).to_not be_nil
            
        end

        describe "with data in DB" do

            let!(:products) { create_list(:product, 9) }
            
            it "should return a complete list of products" do
                get "/products"
                expect(payload.size).to eq(products.size)
                expect(payload).to_not be_empty 
                expect(response).to have_http_status(:ok)

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