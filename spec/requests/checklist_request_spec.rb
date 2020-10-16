require 'rails_helper'

RSpec.describe "Checklists", type: :request do
  let(:user) do
    u = create(:user)
    u.add_role "employee"
    u.add_role "dispatcher"
    u
  end

    
  describe 'logged in users' do
    it 'Employee can check a product single product' do

      order = create_order user
      line = order.order_lines[0]
      post "/checklist/#{line.id}"

      line.reload

      expect(response).to have_http_status(:ok)
      expect(line.check).to eq(true)
          
    end
  end

end


def create_order(user, with_lines = true)
  
    order = create(:order, user_id: user.id)
    
    if with_lines 
      products = create_list(:product, 10)
      products.each do |p|
        order.order_lines.create(product_id: p['id'], quantity: 2, price: p['retail_price'], unit_type: 'Unit')
      end
    end
    
    order
  end
  