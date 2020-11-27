class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:destroy]
  load_and_authorize_resource
  
  def index
    @users = User.preload(:roles)
    render json: @users, include: [:roles]
  end

  def show
    @user = User.find(params[:id])
    render json: @user, include: [:roles]
  end

  def create

    if params[:roles].present? && !params[:roles].empty?

      errors = []

      params[:roles].each do |role|

        case role
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
      end

      if !errors.empty?
        return render json: {error: errors}, status: 403
      end

    end
    
    @user = User.create!(create_params)

    if params[:roles].present? && !params[:roles].empty?
      params[:roles].each do |role|
        @user.add_role role
      end
    end
    
    render json: @user, status: :created
  end

  def destroy

    @user.destroy 

    render json: { message: 'Record deleted!' }, status: :ok

  end

  def update

    @user = User.find(params[:id])

    if params[:roles].present? && !params[:roles].empty?

      errors = []

      params[:roles].each do |role|

        case role
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
      end

      if !errors.empty?
        return render json: {error: errors}, status: 403
      end

    end

    @user.update!(update_params)

    if params[:roles].present? && !params[:roles].empty?
      params[:roles].each do |role|
        @user.add_role role
      end
    end


    render json: @user, status: :ok
  end
  
  def me 
    render json: current_user, include: [:roles], status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def create_params
    params.permit(:first_name, :last_name, :phone, :email, :password)
  end

  def update_params
    params.permit(:first_name, :last_name, :phone, :email, :password)
  end
end