require 'rails_helper'

RSpec.describe OrderLine, type: :model do
  describe "validations" do
    it { should validate_presence_of(:order_id) }
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_type) }
  end

  describe "Relationships" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe 'Default values' do
    it 'Status check' do

      p = create(:product)
      o = create(:order)

      ol = o.order_lines.create(product_id: p['id'], quantity: 2, price: p['retail_price'], unit_type: 'Unit')

      expect(ol.check).to eq(false)
      
    end
  end
end
