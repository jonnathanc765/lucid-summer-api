class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
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

    if params[:role].present?
      errors = []
      case params[:role]
      when "admin"
        if (!current_user.has_role? "admin")
          errors.push('You dont have permission for this action!')
        end
      else
        errors = []
      end

      if !errors.empty?
        return render json: {error: errors}, status: :unprocessable_entity
      end

      @user.add_role params[:role]
    end

    render json: @user, status: :created
  end

  def update
    @user = User.find(params[:id])
    @user.update!(update_params)

    render json: @user, status: :ok
  end
  
  def me 
    render json: current_user, status: :ok
  end

  private
    def create_params
      params.permit(:first_name, :last_name, :phone, :email, :password)
    end

    def update_params
      params.permit(:first_name, :last_name, :phone, :email, :password)
    end
end
