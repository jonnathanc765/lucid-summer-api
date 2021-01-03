class ChecklistController < ApplicationController

  def check

    @order_line = OrderLine.preload(:product).find(params[:id]) 
    @order_line.update!(check: true)

    if @order_line.order.status == "pending"
      @order_line.order.status = "on_process" 
      @order_line.order.save!
    end

    # for return product with thumbnail

    product = @order_line.product
              
    product = product.as_json.merge(
      images: product.images.map { 
        |image| { id: image.id, url: url_for(image) } 
      }
    )

    order_line = @order_line.as_json.merge(
      product: product
    )

    render json: order_line, status: :ok
  end
end
