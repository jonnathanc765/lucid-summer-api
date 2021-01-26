class CoordinatesController < ApplicationController
  before_action :set_coordinate, only: [:update, :destroy]
  load_and_authorize_resource


  def index 
    render json: Coordinate.all, status: :ok
  end

  def create 

    @coordinate = Coordinate.create!(create_params)
    render json: @coordinate, status: :created

  end

  def update 

    @coordinate.update!(create_params)
    render json: @coordinate, status: :ok

  end

  def destroy 

    @coordinate.destroy!
    render json: { message: 'Coordinate deleted' }, status: :ok

  end

  private 

  def create_params
    params.permit(:zip_code)
  end

  def set_coordinate
    @coordinate = Coordinate.find(params["id"])
  end

end
