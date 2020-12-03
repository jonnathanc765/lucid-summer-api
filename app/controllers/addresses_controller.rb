class AddressesController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource


    def index
        @addresses = current_user.addresses
        render json: @addresses, status: :ok
    end

    def show
        render json: @address, status: :ok
    end

    def create
        @address = current_user.addresses.create(address_params)
        render json: @address, status: :created
    end

    def update
        @address.update!(address_params)
        render json: @address, status: :ok
    end

    def destroy 
        @address.destroy 
        render json: {message: "Record deleted"}, status: :ok
    end

    private 

    def address_params
        params.permit(:address, :city, :state, :country)
    end

    def set_address
        @address = Adress.find(params[:id])
    end

end