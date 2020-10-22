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
end
