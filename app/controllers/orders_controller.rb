class OrdersController < ApplicationController
  def new
    @order = Order.new
  end
  def create
    @order = Order.new(order_params)
    @order.cart = current_cart

    if @order.save
      session[:cart_id] = nil
      redirect_to root_path, notice: "Order placed successfully."
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :email, :address, :pay_type)
  end
end
