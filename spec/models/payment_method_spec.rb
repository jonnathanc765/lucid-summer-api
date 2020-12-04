require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do

  it 'validations' do
    should validate_presence_of(:user_id)
    should validate_presence_of(:unique_id)
  end

  it 'relationships' do
    should belong_to(:user)
  end

end
