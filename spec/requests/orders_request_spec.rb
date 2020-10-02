require 'rails_helper'

RSpec.describe "Orders", type: :request do

end
require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "GET /orders" do

    let!(:order) { create_list(:order, 10) }

    it "its neccesary a logged user for access to list of orders" do 
        get "/orders"

        expect(response).to have_http_status(401)
    end


    
  end
end
