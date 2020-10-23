class ProductImagesController < ApplicationController
  before_action :authenticate_user!

  def create

    @product = Product.find(params[:id])

    authorize! :attach_images, Product

    params[:images].each_value do |image| 
      @product.images.attach(image)
    end

    render json: @product, includes: [:images], status: :created
  end
  

end
