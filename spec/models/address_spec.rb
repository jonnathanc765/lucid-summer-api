require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "Test for Address model" do
    it "Validations" do 
      should validate_presence_of(:user_id)
      should validate_presence_of(:address)
      should validate_presence_of(:state)
      should validate_presence_of(:country)
    end
    it "Relationships" do 
      should belong_to(:user)
    end
  end
end
