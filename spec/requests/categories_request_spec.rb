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
        
    end

    describe "DELETE /products/:id" do

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