class ProductImagesController < ApplicationController
  #before_action :authenticate_user!
  #load_and_authorize_resource

  def create

    @product = Product.find(params[:id])
    @product.images.attach(params[:images])

    render json: @product, includes: [:images], status: :created
  end
  

end
