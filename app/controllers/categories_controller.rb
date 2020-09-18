class CategoriesController < ApplicationController

    def index 
        @categories = Category.all 
        render json: @categories, status: :ok
    end

    def create 
        @categories = Category.create!(category_params)
        render json: @categories, status: :created
    end

    def update
        @category = Category.find(params[:id])
        @category.update!(category_params)
        render json: @category, status: :ok
    end
    

    private 

    def category_params 
        params.permit(:name, :description)
    end

end