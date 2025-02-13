class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: [:new, :create]
  before_action :set_order, only: [:show, :payment]
  before_action :set_order_for_guest_or_user, only: [:new, :create, :payment]

  def index
    @orders = Order.all
  end

  def show
    @amount = @order.calculate_total_price

    if @amount && @amount > 0
      @payment_intent = create_payment_intent(@amount)
    else
      flash.now[:alert] = "Unable to process payment for this order."
      render :show
    end
  rescue StandardError => e
    handle_error(e)
  end

  def payment
    redirect_to payments_path(order_id: @order.id), method: :post
  rescue StandardError => e
    handle_error(e)
  end

  def payment
    @order = Order.find(params[:id])
    redirect_to payments_path(order_id: @order.id), method: :post
  end

  def new
    Rails.logger.debug "Params: #{params.inspect}"
    @order = Order.new
  end

  def new_guest
    @order = Order.new
  end

  def create
    @order = set_order_for_guest_or_user
    @order.cart = @cart

    if @order.save
      clear_cart_session
      redirect_to order_path(@order), notice: "Order placed successfully. Please proceed with payment."
    else
      flash.now[:alert] = "There was an error creating your order: #{@order.errors.full_messages.join(', ')}"
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

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found"
  end

  def create_payment_intent(amount)
    Stripe::PaymentIntent.create({
      amount: (amount * 100).to_i,
      currency: 'usd',
    })
  end

  def clear_cart_session
    session[:cart_id] = nil
  end

  def handle_error(error)
    Rails.logger.error "Error: #{error.message}"
    redirect_to root_path, alert: "An error occurred. Please try again later."
  end
  def set_order_for_guest_or_user
    if user_signed_in?
      @order = params[:action] == 'create' ? current_user.orders.build(order_params) : current_user.orders.build
    else
      @order = params[:action] == 'create' ? Order.new(order_params) : Order.new
    end
  end



end
