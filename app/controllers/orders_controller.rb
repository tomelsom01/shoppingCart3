class OrdersController < ApplicationController
  
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found"
  end

  def new
    @order = Order.new
  end

  def new_guest
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.cart = @cart  # Use @cart instead of current_cart

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

  def ensure_cart_isnt_empty
    if @cart.cart_items.empty?
      redirect_to root_path, alert: "Your cart is empty"
    end
  end

  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
