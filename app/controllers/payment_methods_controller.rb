require 'openpay'

class PaymentMethodsController < ApplicationController
  before_action :authenticate_user!

  def create

    @openpay = OpenpayApi.new("mihqpo64jxhksuoohivz","sk_f6aafbacebd64882a224446b1331ef3c")

    @cards = @openpay.create(:cards)
    
    address = Address.find(params[:address_id])

    req_payload = {
      :holder_name => params[:holder_name],
      :card_number => params[:card_number],
      :cvv2 => params[:cvv2],
      :expiration_month => params[:expiration_month],
      :expiration_year => params[:expiration_year],
      :device_session_id => params[:device_session_id],
      :address => {
        :line1 => address.line,
        :line2 => nil,
        :line3 => nil,
        :state => address.state,
        :city => address.city,
        :postal_code => address.zip_code,
        :country_code => "MX"
      }
    }


    begin

      response = @cards.create(req_payload, current_user.customer_id)

      @payment_method = current_user.payment_methods.create!(
        unique_id: response["id"],
        hashed_card_number: response["card_number"],
        card_brand: response["brand"],
      )

    rescue => exception

      return render json: { message: exception.description }, status: exception.http_code  

    end

    return render json: @payment_method, status: :created

  end

  def index
    
    @payment_methods = current_user.payment_methods
    render json: @payment_methods, status: :ok
  end



  private

  def create_params

    params.permit(:holder_name, :card_number, :cvv2, :expiration_month, :expiration_year, :device_session_id)

  end 

end
