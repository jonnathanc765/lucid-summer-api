require 'openpay'

class PaymentMethodsController < ApplicationController
  before_action :authenticate_user!

  def create

    @openpay = OpenpayApi.new("mihqpo64jxhksuoohivz", "sk_f6aafbacebd64882a224446b1331ef3c")

    @cards = @openpay.create(:cards)
    
    address = Address.find(params[:address_id])

    req_payload = create_params.merge(
      :address => {
        "line1" => address.line,
        "line2" => nil,
        "line3" => nil,
        "state" => address.state,
        "city" => address.city,
        "postal_code" => address.zip_code,
        "country_code" => "MX"
      }
    )

    binding.pry

    response = @cards.create(req_payload, current_user.customer_id)

    render json: response, status: :created

  end


  private

  def create_params

    params.permit(:holder_name, :card_number, :cvv2, :expiration_month, :expiration_year)

  end 

end
