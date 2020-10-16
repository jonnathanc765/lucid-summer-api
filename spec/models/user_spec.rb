require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'validate presence of fields of users' do
      should validate_presence_of(:first_name)
      should validate_presence_of(:last_name)
      should validate_presence_of(:email)
      should validate_presence_of(:phone)
    end

    it { should have_many(:addresses) }
    it { should have_many(:reviews) }
  end
end
