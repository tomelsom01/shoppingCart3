class OrdersController < ApplicationController
  before_action :set_cart, only: [:new, :create]
  before_action :ensure_cart_isnt_empty, only: [:new, :create]
  before_action :set_order, only: [:show, :payment]
  before_action :set_order_for_guest_or_user, only: [:new, :create]

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

  def new
    Rails.logger.debug "Params: #{params.inspect}"
    @order = Order.new
  end

  def new_guest
    @order = Order.new
  end

  def create
    @order = Order.find(params[:order_id])
    token = params[:stripeToken]

    # Create the charge in Stripe
    charge = Stripe::Charge.create({
      amount: (@order.total_price * 100).to_i,
      currency: 'usd',
      source: token,
      description: "Charge for Order ##{@order.id}"
    })

    # If the charge is successful, save the token to the order
    if charge.paid
      @order.update(stripe_token: token, status: 'paid')
      redirect_to order_path(@order), notice: 'Payment successful!'
    else
      redirect_to order_path(@order), alert: 'Payment failed.'
    end

  rescue Stripe::CardError => e
    redirect_to order_path(@order), alert: e.message
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

  def process_payment
    # Here you would typically use the Stripe token to create a charge or payment intent
    # This is just a placeholder - implement your actual payment logic here
    if params[:stripeToken]
      # Process payment using Stripe
      # You might want to add the charge ID or payment intent ID to the order
      @order.update(payment_status: 'paid')
    end
  end


end
