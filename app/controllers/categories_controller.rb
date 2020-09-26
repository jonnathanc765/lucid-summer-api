class CategoriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @categories = Category.all
    render json: @categories, status: :ok
  end

  def create
    @categories = Category.create!(category_params)
    render json: @categories, status: :created
  end

  def update
    @category.update!(category_params)
    render json: @category, status: :ok
  end

  def destroy
    @category.destroy
    render json: {message: "Record deleted"}, status: 200
  end

  private
    def category_params
      params.permit(:name, :description, :color)
    end

    def set_category
      @category = Category.find(params[:id])
    end
end
