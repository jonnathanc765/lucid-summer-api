require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validate fields" do
    it "should validate all fields" do
      should validate_presence_of(:user_id)
      should validate_presence_of(:address)
      should validate_presence_of(:city)
      should validate_presence_of(:state)
      should validate_presence_of(:country)
      should validate_presence_of(:delivery_date)
    end
  end

  describe "Relationships" do
    it "a order have order-lines" do
      should have_many(:order_lines)
    end
    it { should have_many(:reviews) }
  end
  it 'have enum status' do
    should define_enum_for(:status).
      with_values([:pending, :on_process, :to_deliver, :in_transit, :delivered, :rated, :cancelled])
  end

  describe 'description' do
    
    it 'Method for subtotal is correct' do
      order = create_order
      expect(order.subtotal).to eq(45)
    end
    
    it 'Method subtotal is correct' do
      order = create_order
      expect(order.total).to eq(52.20)
    end

  end 


end

def create_order 
  order = create(:order)
  create(:order_line, order_id: order.id, price: 10, quantity: 1) 
  create(:order_line, order_id: order.id, price: 20, quantity: 1) 
  create(:order_line, order_id: order.id, price: 15, quantity: 1) 
  order
end
