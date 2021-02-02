require 'csv'

class ProductsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => :related_products

  def index

    where_conditions = {}
    if search_params[:categories].present?
      where_conditions[:category_id] = search_params[:categories]
    end

    name = ''

    if search_params[:name].present?
      
      name = search_params[:name]
      
    end

    @products = Product.where(where_conditions).where("name LIKE '%#{name}%'").order(id: :desc).includes(:category)

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
      @products = Product.where(category_id: params[:category_id]).limit(25).order_by_rand.limit(25)
    else
      @products = Product.order_by_rand.limit(25)
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

  def import 

    file = params[:products_file]
    parsed = CSV.read(file)
    header = parsed[0]

    if !"id".in?(header) || !"name".in?(header) || !"retail_price".in?(header) || !"promotion_price".in?(header) || !"wholesale_price".in?(header) || !"approximate_weight_per_piece".in?(header)
      return render json: {message: 'error'}, status: :bad_request
    end

    CSV.foreach(file, headers: true) do |row|
      product = Product.find(row["id"])
      if !product.nil?
        product.update(name: row["name"], retail_price: row["retail_price"], promotion_price: row["promotion_price"], wholesale_price: row["wholesale_price"], approximate_weight_per_piece: row["approximate_weight_per_piece"])
      end
    end

    render json: {message: 'success'}, status: :ok

  end

  private

  def product_params
    params.permit(:name, :retail_price, :wholesale_price, :promotion_price, :approximate_weight_per_piece, :category_id, :exempt, :sat)
  end

  def search_params
    params.permit(:name, :categories)
  end

  def set_product
    @product = Product.find(params[:id]).includes(:images)
  end

end
