class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.create!(create_params)
    render json: @user, status: :created
  end

  def update
    @user = User.find(params[:id])
    @user.update!(update_params)

    render json: @user, status: :ok
  end

  private
    def create_params
      params.permit(:first_name, :last_name, :phone, :email, :password)
    end

    def update_params
      params.permit(:first_name, :last_name, :phone, :email, :password)
    end
end
