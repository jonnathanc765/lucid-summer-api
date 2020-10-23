require 'rails_helper'

RSpec.describe "ProductImages ~>", type: :request do

  let(:user) do 
    u = create(:user)
    u.add_role "admin"
    u
  end

  sign_in(:user)

    describe 'Product attachments ~>' do

        let(:image) { fixture_file_upload('spec/storage/Products/apple.png', 'image/png') }

        describe 'POST /product_images/:id ~>' do
          
            it 'user can attach image to products' do

              product = create(:product)

              req_payload = Hash.new
              req_payload['images'] = [image] 

              post "/product_images/#{product.id}", params: req_payload
        
              expect(response).to have_http_status(:created)
              expect(product.images.size).to eq(1)
        
            end

            it 'product must exist' do

              product = create(:product)

              req_payload = {images: image}
              
              post "/product_images/343", params: req_payload
        
              expect(response).to have_http_status(:not_found)

            end

            it 'Only admin can store product image' do

              user.remove_role "admin"
              user.add_role "client"

              product = create(:product)

              req_payload = {images: image}
              
              post "/product_images/#{product.id}", params: req_payload
        
              expect(response).to have_http_status(:forbidden)
            end

        end
    
    end

end
