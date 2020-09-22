require 'rails_helper'

RSpec.describe "Products", type: :request do

    describe "GET /products" do
        before { get '/products' }

        it "should return status code 200" do

            expect(response).to have_http_status(:ok)
            expect(payload).to_not be_nil
            
        end

        let!(:products) { create_list(:product, 10) }

        it "should return a complete list of products" do
            expect(payload).to_not be_empty
            expect(payload.size).to eq(10)
            expect(response).to have_http_status(:ok)
        end
        
        
    end
    

end