class ChecklistController < ApplicationController

  def check

      @order_line = OrderLine.find(params[:id]) 
      @order_line.update!(check: true)
      if @order_line.order.status == "pending"
        @order_line.order.status = :on_process 
        @order_line.order.save!
      end

      render json: @order_line, status: :ok
  end
end
