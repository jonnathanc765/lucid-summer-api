require 'rails_helper'

RSpec.describe "Coordinates", type: :request do

  let!(:user) do 
    u = create(:user)
    u.add_role "admin"
    u
  end
  sign_in(:user)

  it 'all can retrieve list of coordinates' do

    create_list(:coordinate, 10)

    get "/coordinates"
    expect(response).to have_http_status(:ok)
    expect(payload.size).to eq(10)
    
  end


  describe 'POST /coordinates' do
    
    it 'admin can create coordinates with a zipcode' do
      
      post "/coordinates", params: { zip_code: "231232" }

      expect(response).to have_http_status(:created)
      expect(Coordinate.all.size).to eq(1)
      c = Coordinate.first
      expect(c.zip_code).to eq("231232")
      expect(payload).to_not be_empty
      expect(payload["zip_code"]).to eq("231232")


    end

  end

  describe 'PUT /coordinates/:id' do
    
    it 'admin can update coordinates with a zipcode' do

      coordinate = create(:coordinate)
      
      put "/coordinates/#{coordinate.id}", params: { zip_code: "231232" }

      expect(response).to have_http_status(:ok)
      expect(Coordinate.all.size).to eq(1)
      coordinate.reload
      expect(coordinate.zip_code).to eq("231232")
      expect(payload).to_not be_empty
      expect(payload["zip_code"]).to eq("231232")


    end

  end

  it 'admin can destroy coordinates' do

    coordinate = create(:coordinate)
      
    delete "/coordinates/#{coordinate.id}"

    expect(response).to have_http_status(:ok)
    expect(Coordinate.all.size).to eq(0)
    expect(payload["message"]).to eq("Coordinate deleted")

  end


end