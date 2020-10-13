class CategoriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @categories = Category.all
    render json: @categories, status: :ok
  end

  def create
    @category = Category.new(category_params)

    if params[:parent_category].present?
      parent_category = Category.where(id: params[:parent_category].to_i)[0]

      if parent_category.nil?
        return render json: {"message" => "Parent category must exists ship must be exists"}.to_json, status: :unprocessable_entity
      end
      
      @category.parent_category = parent_category
    end
    @category.save!
    render json: @category, status: :created
  end

  def update
    if params[:parent_category].present?

      parent_category = Category.where(id: params[:parent_category].to_i)[0]

      if parent_category.nil?
        return render json: {"message" => "Parent category must exists ship must be exists"}.to_json, status: :unprocessable_entity
      end

      if parent_category.id == @category.id
        return render json: {"message" => "Parent category can't be the same category"}.to_json, status: :unprocessable_entity
      end

      @category.parent_category = parent_category

    end
    @category.update(category_params)
    render json: @category, status: :ok
  end

  def destroy
    @category.destroy
    render json: {message: "Record deleted"}, status: :ok
  end

  private
    def category_params
      params.permit(:name, :description, :color)
    end

    def set_category
      @category = Category.find(params[:id])
    end

end
