class ReviewsController < ApplicationController
    before_action :authenticate_user!, only: [:create]
    load_and_authorize_resource

    def create

      errors = []

      case params[:reviewable_type]

      when "user"
        model = User.find_by(id: params[:id])
        if model.nil?
          errors.push "Product must exists"
        end
      when "order"
        model = Order.find_by(id: params[:id])
        if model.nil?
          errors.push "Order must exists"
        end
      else
        errors.push "Model specified it's wrong"
      end
      
      if !errors.empty?
        return render json: {message: errors}, status: :unprocessable_entity
      end
    
      @review = model.reviews.create!(review_params)

      render json: @review, status: :created
    end

    def show 
      @review = Review.find(params[:id])
      render json: @review, status: :ok
    end

    private

    def review_params 
      params.permit(:title, :description, :stars)
    end

end
