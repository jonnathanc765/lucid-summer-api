require 'rails_helper'

RSpec.describe "PaymentMethods", type: :request do

  let(:openpay) do 
    openpay = OpenpayApi.new("mihqpo64jxhksuoohivz","sk_f6aafbacebd64882a224446b1331ef3c")
    openpay 
  end

  let(:client_user) do
    user = create(:user)
    user.add_role "client" 
    user
  end

  sign_in(:client_user)

  let(:valid_address) do
    create(:address, user_id: client_user.id)
  end

  let(:customer) do 

    @customer = openpay.create(:customers)

    customer_payload = {
      "external_id" => nil,
      "name" => client_user.first_name,
      "last_name" => client_user.last_name,
      "email" => client_user.email,
      "requires_account" => false,
      "phone_number" => client_user.phone,
      "address" => {
        "line1" => valid_address.line,
        "line2" => nil,
        "line3" => nil,
        "state" => valid_address.state,
        "city" => valid_address.city,
        "postal_code" => valid_address.zip_code,
        "country_code" => "MX"
      }
    }

    response = @customer.create(customer_payload)
    client_user.customer_id = response["id"]
    client_user.save!

    @customer
  end

  describe 'logged in users' do

    sign_in(:client_user)

    it 'clients can create new pay methods' do

      req_payload = { 
        "holder_name" => "Juan Perez Ramirez",
        "card_number" => "4242424242424242",
        "cvv2" => "110",
        "expiration_month" => "12",
        "expiration_year" => "25",
        "device_session_id" => nil,
        'address_id' => valid_address.id
      }
  
      post '/payment_methods', params: req_payload
  
      expect(response).to have_http_status(:created)
      expect(payload["id"]).to_not be_nil
      expect(payload["type"]).to_not be_nil
      expect(payload["brand"]).to_not be_nil
      expect(payload["card_number"]).to_not be_nil
      expect(payload["holder_name"]).to_not be_nil
      expect(payload["expiration_year"]).to_not be_nil
      expect(payload["expiration_month"]).to_not be_nil
      expect(payload["allows_charges"]).to_not be_nil
      expect(payload["allows_payouts"]).to_not be_nil
      expect(payload["creation_date"]).to_not be_nil
      expect(payload["bank_name"]).to_not be_nil
      payment_method = PaymentMethod.all 
      expect(payment_method.size).to eq(1)
      payment_method = payment_method.first 
      expect(payment_method.card_brand).to eq('visa')
      expect(payment_method.hashed_card_number).to eq('424242XXXXXX4242')
      expect(payment_method.user_id).to eq(client_user.id)

    end
  end
end