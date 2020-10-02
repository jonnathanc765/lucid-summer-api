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
end
