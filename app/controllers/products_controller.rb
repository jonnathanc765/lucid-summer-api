class ProductsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    where_conditions = {}

    if search_params[:categories].present?
      where_conditions[:category_id] = search_params[:categories]
    end

    
    if params[:name].present?
      where_conditions[:name] = params[:name]
    end

    @products = Product.where(where_conditions).order(id: :desc).includes(:category)

    render json: @products, include: [:category], status: :ok
  end

  def show

    render json: @product.as_json.merge(images: @product.images.map { |image| { id: image.id, url: url_for(image) } }), status: :ok
    
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

  def related_products 

    if params[:category_id].present? 
      @products = Product.order(Arel.sql('RANDOM()')).where(category_id: params[:category_id]).limit(25)
    else
      @products = Product.order(Arel.sql('RANDOM()')).limit(25)
    end

    @products = @products.map do |product|
      product.as_json.merge(
        images: product.images.map { 
          |image| { id: image.id, url: url_for(image) } 
        } 
      )
    end

    render json: @products, status: :ok

  end

  private

  def product_params
    params.permit(:name, :retail_price, :wholesale_price, :promotion_price, :approximate_weight_per_piece, :category_id)
  end

  def search_params
    params.permit(categories: [])
  end

  def set_product
    @product = Product.find(params[:id]).includes(:images)
  end

end
