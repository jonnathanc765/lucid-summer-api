require 'rails_helper'

RSpec.describe CartLine, type: :model do
  
  describe "validations" do

    it { should validate_presence_of(:cart_id) }
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:quantity) }

    
  end

  describe "Relationships" do

    it { should belong_to(:cart) } 
    it { should belong_to(:product) }
    
  end
  
  
end
