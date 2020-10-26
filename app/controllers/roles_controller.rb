class RolesController < ApplicationController

    def index
        render json: Role.all, status: :ok
    end
end
