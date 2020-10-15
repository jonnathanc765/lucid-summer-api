require 'rails_helper'

RSpec.describe "ProductImages", type: :request do

    describe 'Product attachments' do

        let(:image) { UploadedFile.new("spec/storage/Products/apple.jpg", "mime/type") }

        describe 'POST /product_images/:id' do
          
            it 'user can attach image to products' do
              
              product = create(:product)

              binding.pry

              req_payload = {images: image}

              post "/product_images/#{product.id}", params: req_payload

              # expect(response).to have_http_status(:created)
              expect(product.images.size).to eq(1)
        
            end

        end
    
    end

end
