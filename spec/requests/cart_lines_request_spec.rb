require 'rails_helper'

RSpec.describe "CartLines", type: :request do
  let(:user) do
    u = create(:user)
    u.add_role "client"
    u
  end

  sign_in(:user)

  let(:products) { create_list(:product, 2) }

  describe "Adding lines ~>" do
    it "a client can add lines to cart" do
      cart = user.create_cart

      req_payload = {
        cart_lines: [
          {
            product_id: products[0].id,
            quantity: 2,
            unit_type: 'Kg'
          },
          {
            product_id: products[1].id,
            quantity: 10
          }
        ]
      }

      post "/cart_lines", params: req_payload

      expect(response).to have_http_status(:created)
      expect(payload).to_not be_empty
      expect(payload[0]["product_id"]).to eq(products[0]["id"])
      expect(payload[1]["product_id"]).to eq(products[1]["id"])
      expect(payload[0]["quantity"]).to eq(2)
      expect(payload[1]["quantity"]).to eq(10)
      expect(CartLine.all.count).to eq(2)
      expect(Cart.all.count).to eq(1)
    end

    it "if the cart line is existing, the product is increment" do
      cart = user.create_cart
      cart.cart_lines.create(product_id: products[0].id, quantity: 2)

      req_payload = {
          cart_lines:
          [
              {product_id: products[1].id, quantity: 10},
              {product_id: products[0].id, quantity: 20}
          ]
      }

      post "/cart_lines", params: req_payload

      expect(response).to have_http_status(:created)
      expect(payload).to_not be_empty
      expect(payload[0]["product_id"]).to eq(products[0]["id"])
      expect(payload[1]["product_id"]).to eq(products[1]["id"])
      expect(payload[0]["quantity"]).to eq(22)
      expect(payload[1]["quantity"]).to eq(10)
      expect(CartLine.all.count).to eq(2)
      expect(Cart.all.count).to eq(1)
    end
  end

  describe "with a existing cart" do
    let(:cart) { user.create_cart }
    before do
      cart.cart_lines.create(quantity: 2, product_id: products[0].id)
      cart.cart_lines.create(quantity: 2, product_id: products[1].id)
    end

    describe "Deleting" do
      it "users can delete a product for a cart" do
        cart_line = CartLine.first
        delete "/cart_lines/#{cart_line.id}"
        expect(response).to have_http_status(:ok)
        expect(payload).to_not be_empty
        expect(CartLine.all.count).to eq(1)
        expect(CartLine.first.id).to eq(2)
      end
    end

    it "if line quantity is set 0, line is deleted" do 
      req_payload = {
        cart_lines: [
          { product_id: products[0].id , quantity: 0 }
        ]
      }
      post "/cart_lines", params: req_payload 
      expect(response).to have_http_status(:created)
      expect(cart.cart_lines.size).to eq(1)
      expect(cart.cart_lines.first.product_id).to eq(products[1].id)
    end
    
  end
end
