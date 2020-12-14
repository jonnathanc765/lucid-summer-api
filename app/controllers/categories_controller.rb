class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :destroy, :update]
  # load_and_authorize_resource

  def index
    if params[:limit].present?
      @categories = Category.includes(:parent_category).limit(params[:limit].to_i)
    else 
      @categories = Category.includes(:parent_category).all
    end
    render json: @categories, include: :parent_category, status: :ok
  end

  def show
    render json: @category, include: [:parent_category], status: :ok
  end

  def create
    @category = Category.create!(category_params)

    render json: @category, status: :created
  end

  def update
    @category.update!(category_params)

    render json: @category, status: :ok
  end

  def destroy
    @category.destroy
    render json: {message: "Record deleted"}, status: :ok
  end

  def limited

    authorize! :read_limited_categories, Category

    @categories = LimitedCategory.includes(:products).limit(5)

    render json: @categories, status: :ok

  end

  private
    def category_params
      params.permit(:name, :description, :color, :parent_category_id)
    end

    def set_category
      @category = Category.find(params[:id])
    end

end
