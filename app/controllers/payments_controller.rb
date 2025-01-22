class PaymentsController < ApplicationController
  before_action :authenticate_user!
  def index
    @purchases = current_user&.purchases
  end
  def create
    Rails.logger.info "Starting payment process for order #{params[:order_id]}"

    @order = Order.find_by(id: params[:order_id])
    unless @order
      Rails.logger.error "Order not found: #{params[:order_id]}"
      return redirect_to root_path, alert: "Order not found"
    end

    @amount = @order.total_price.to_f
    Rails.logger.info "Order amount: #{@amount}"

    begin
      Rails.logger.info "Creating Stripe customer"
      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )
      Rails.logger.info "Stripe customer created: #{customer.id}"

      Rails.logger.info "Creating Stripe charge"
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: (@amount * 100).to_i,
        description: "Payment for Order ##{@order.id}",
        currency: 'usd'
      )
      Rails.logger.info "Stripe charge created: #{charge.id}"

      @order.update(status: 'paid')
      Rails.logger.info "Order status updated to paid"

      redirect_to payments_path(order_id: @order.id), notice: 'Payment successful!'
    rescue Stripe::CardError => e
      Rails.logger.error "Stripe CardError: #{e.message}"
      flash[:error] = e.message
      redirect_to order_path(@order)
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe Error: #{e.message}"
      flash[:error] = "An error occurred with Stripe. Please try again."
      redirect_to order_path(@order)
    rescue => e
      Rails.logger.error "General Error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash[:error] = "An unexpected error occurred. Please try again."
      redirect_to order_path(@order)
    end
  end
end
