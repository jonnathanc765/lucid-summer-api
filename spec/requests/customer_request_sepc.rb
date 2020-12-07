require 'rails_helper'

RSpec.describe "Customers", type: :request do


  it 'clients are registered with customer (open pay)' do
    users = User.all
    req_payload = { first_name: "Jose", last_name: "Perez", email: "jose@perez.com", phone: "+512 584 84765", password: "password" }
    post "/users", :params => req_payload
    expect(response).to have_http_status(:created)
    expect(payload).to_not be_empty
    expect(payload["id"]).to_not be_nil
    expect(users.size).to eq(1)
    expect(users.first.customer_id).to_not be_nil
  end
 

end