require 'rails_helper'

RSpec.describe "AvailableDates", type: :request do

  describe 'For clients (Logged in users)' do



    describe 'GET /avalaible_dates' do
      
      it 'Clients can get avalaible dates for their orders' do
        
        get "/available_dates"

        expect(response).to have_http_status(:ok)
        expect(payload).to_not be_empty
        expect(payload[0]).to_not be_nil 
        expect(payload[1]).to_not be_nil 
        expect(payload[0]["date"]).to_not be_nil 
        expect(payload[1]["date"]).to_not be_nil 

      end
    end
    
  end

end