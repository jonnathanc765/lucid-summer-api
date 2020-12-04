require 'rails_helper'

RSpec.describe "Healths", type: :request do

  let(:openpay) do 
    openpay = OpenpayApi.new("mzdtln0bmtms6o3kck8f","sk_e568c42a6c384b7ab02cd47d2e407cab")
    openpay 
  end

  let(:client_user) do
    user = create(:user)
    user.add_role "client" 
  end

  sign_in(:client_user)

  let(:valid_address) { create(:address, user_id: user.id) }

  let(:customer) do 
    @customer = @openpay.create(:customers)
    req_payload = {
      "external_id" => client_user.id,
      "name" => client_user.first_name,
      "last_name" => client_user.last_name,
      "email" => client_user.email,
      "requires_account" => false,
      "phone_number" => client_user.phone,
      "address" => {
        "line1" => valid_address.address,
        "line2" => nil,
        "line3" => nil,
        "state" => valid_address.state,
        "city" => valid_address.city,
        "postal_code" => valid_address.zipcode,
        "country_code" => "MX"
      }
    }
    response = @customer.create(req_payload)

    response
  end

  it 'clients can create new pay methods' do
    
  end

  @cards=@openpay.create(:cards)

  request_hash={
      "holder_name" => "Juan Perez Ramirez",
      "card_number" => "411111XXXXXX1111",
      "cvv2" => "110",
      "expiration_month" => "12",
      "expiration_year" => "20",
      "device_session_id" => "kR1MiQhz2otdIuUlQkbEyitIqVMiI16f",
      "address" => address_hash
    }

  response_hash=@cards.create(request_hash.to_hash, "asynwirguzkgq2bizogo")

end