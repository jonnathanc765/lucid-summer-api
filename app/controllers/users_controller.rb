class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
    @users = User.all
    render json: @users, include: [:roles]
  end

  def show
    @user = User.find(params[:id])
    render json: @user, include: [:roles]
  end

  def create

    if params[:role].present?
      errors = []
      case params[:role]
      when "admin"
        if !current_user.has_any_role? "admin", "super-admin"
          errors.push('You dont have permission for this action!')
        end
      when "super-admin"
        if (!current_user.has_role? "super-admin")
          errors.push('You dont have permission for this action!')
        end
      else
        errors = []
      end 
      if !errors.empty?
        return render json: {error: errors}, status: 403
      end
    end
    
    @user = User.create!(create_params)

    @user.add_role params[:role]
    
    render json: @user, status: :created
  end

  def update
    @user = User.find(params[:id])
    @user.update!(update_params)

    render json: @user, status: :ok
  end
  
  def me 
    render json: current_user, include: [:roles], status: :ok
  end

  private
    def create_params
      params.permit(:first_name, :last_name, :phone, :email, :password)
    end

    def update_params
      params.permit(:first_name, :last_name, :phone, :email, :password)
    end
end
