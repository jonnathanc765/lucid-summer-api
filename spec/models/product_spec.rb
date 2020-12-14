require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Validations single product" do
    it "some field should be required" do
      should validate_presence_of(:name)
      should validate_presence_of(:retail_price)
      should validate_presence_of(:wholesale_price)
      should validate_presence_of(:approximate_weight_per_piece)

    end
  end
  it 'relationships' do
    should have_many_attached(:images)
    should belong_to(:category).optional
  end


  it "it return a real price for product" do 
    p1 = create(:product, promotion_price: 10)

    expect(p1.current_price).to eq(10)

    p2 = create(:product, promotion_price: nil, retail_price: 25)

    expect(p2.current_price).to eq(25)
  end
end
