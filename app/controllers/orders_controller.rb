class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: [:new, :create]

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  @amount = @order.total_price

  if @amount && @amount > 0
    @payment_intent = Stripe::PaymentIntent.create({
      amount: (@amount * 100).to_i,
      currency: 'usd',
    })
  else
    flash.now[:alert] = "Unable to process payment for this order."
    render :show
  end
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
    @order.cart = @cart

    if @order.save
      session[:cart_id] = nil
      redirect_to order_path(@order), notice: "Order placed successfully. Please proceed with payment."
    else
      flash.now[:alert] = "There was an error creating your order."
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
