class ProductImagesController < ApplicationController
  before_action :authenticate_user!

  def create

    @product = Product.find(params[:id])
    authorize! :attach_images, Product
    @product.images.attach(params[:images])

    render json: @product, includes: [:images], status: :created
  end
  

end
