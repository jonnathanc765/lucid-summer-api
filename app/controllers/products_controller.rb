class ProductsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @products = Product.all
    render json: @products, status: :ok
  end

  def show
    render json: @product, status: :ok
  end

  def create
    @product = Product.create!(product_params)
    render json: @product, status: :created
  end

  def update
    @product.update!(product_params)
    render json: @product, status: :ok
  end

  def destroy
    @product.destroy
    render json: {message: "Record deleted"}, status: :ok
  end

  private
    def product_params
      params.permit(:name, :retail_price, :wholesale_price, :promotion_price, :approximate_weight_per_piece, :category_id)
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
