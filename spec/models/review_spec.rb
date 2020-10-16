require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:stars) }
  end

  describe 'Relations' do

    it { should belong_to(:reviewable) }
    
  end
end
