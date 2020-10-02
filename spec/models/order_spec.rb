require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validate fields" do
    it "should validate all fields" do
      should validate_presence_of(:user_id)
    end
  end

  describe "Relationships" do
    it "a order have order-lines" do
      should have_many(:order_lines)
    end
  end
end
