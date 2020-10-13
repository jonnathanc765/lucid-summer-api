class AddressesController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource


    def index

        render json: {}, status: :ok
    end
end
