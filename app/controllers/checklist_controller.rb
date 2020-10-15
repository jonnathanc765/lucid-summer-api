class ChecklistController < ApplicationController

  def check
      @order_line = OrderLine.find(params[:id]) 
      @order_line.update!(check: true)

      render json: @order_line, status: :ok
  end
end
