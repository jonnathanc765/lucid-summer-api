require 'rails_helper'

RSpec.describe "Categories", type: :request do

    describe "GET /categories request" do

        
        describe "witout data in DB" do
            
            it "it return a success code for categories list" do 
                get "/categories"
                expect(payload.size).to eq(0)
                expect(payload).to be_empty 
                expect(response).to have_http_status(200)
                
            end

        end
        
        describe "with data in DB" do
            
            let!(:categories) { create_list(:category, 5) }
    
            it "it return a list of caegories" do 
                get "/categories"
                
                expect(payload.size).to eq(5)
                expect(payload).to_not be_empty 
                expect(response).to have_http_status(:ok)
            end

        end

    end

    describe "POST /categories" do

        describe "create a category with correct data" do

            it 'save correctly' do
                
                req_payload = {name: "Herb", description: "Some herbs"}
                post "/categories", params: req_payload
                expect(response).to have_http_status(:created)
                expect(payload["id"]).to_not be_nil  

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

            req_payload = {name: "Herb", description: "Some herbs"}
            put "/categories/#{category.id}", params: req_payload 

            expect(response).to have_http_status(:ok)
            expect(payload["id"]).to_not be_nil 
            expect(payload["id"]).to eq(category.id)    
            
        end
        
    end
    
    
end