module OrdersRequestsHelpers
  def create_cart(user, with_lines = true)

    cart = Cart.create(user_id: user.id)

    if with_lines
      products = create_list(:product, 10)
      products.each do |p|
        cart.cart_lines.create(product_id: p['id'], quantity: 2)
      end
    end

    cart
  end

  def create_order(user, with_lines = true, order_status = 0)
    order = create(:order, user_id: user.id, status: order_status)

    if with_lines
      products = create_list(:product, 10)
      products.each do |p|
        order.order_lines.create(product_id: p['id'], quantity: 2, price: p['retail_price'], unit_type: 'Unit')
      end
    end

    order
  end
end