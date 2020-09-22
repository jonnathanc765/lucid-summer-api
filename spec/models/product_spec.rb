require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Validations single product" do    
    it "some field should be required" do
      should validate_presence_of(:name)
      should validate_presence_of(:retail_price)
      should validate_presence_of(:wholesale_price)
    end
  end
  
end
