class ProductImagesController < ApplicationController
  before_action :authenticate_user!

  def create

    @product = Product.find(params[:product_id])

    authorize! :attach_images, Product

    params[:images].each_value do |image| 
      @product.images.attach(image)
    end

    render json: @product, includes: [:images], status: :created
  end

  def destroy
    @product = Product.find(params[:product_id].to_i)
    @image = @product.images.find(params[:id].to_i)
    @image.purge
    render json: @product.as_json.merge(images: @product.images.map { |image| { id: image.id, url: url_for(image) } })
  end
  
  private 

  def set_product
    @product = Product.find_by(params[:product_id])
  end

end
