require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validate fields" do
    it "should validate all fields" do
      should validate_presence_of(:user_id)
      should validate_presence_of(:address)
      should validate_presence_of(:city)
      should validate_presence_of(:state)
      should validate_presence_of(:country)
    end
  end

  describe "Relationships" do
    it "a order have order-lines" do
      should have_many(:order_lines)
    end
  end
  it 'have enum status' do
    should define_enum_for(:status).
      with_values([:pending, :on_process, :to_deliver, :in_transit, :delivered, :rated])
  end
end
