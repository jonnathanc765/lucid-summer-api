require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "validate fields" do
      it "should validate all fields" do
        should validate_presence_of(:user_id)
      end
      
  end
  
end
