require 'rails_helper'

RSpec.describe Coordinate, type: :model do
  it 'presense of fields' do
    should validate_presence_of(:zip_code)
  end
end
