require 'rails_helper'

RSpec.describe Role, type: :model do

  describe "Validations" do
    it "Name field must be presence" do
      should validate_presence_of(:name)
    end
  end
  
end
