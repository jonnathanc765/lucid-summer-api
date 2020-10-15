class ProductImagesController < ApplicationController

  def create

    
    product = Product.find(params[:id])
    binding.pry
    
    product.images.attach(images_params[:images])

    render json: product, include: [:images], status: :created
  end

  def images_params
    params.permit(:images)
  end 

end
