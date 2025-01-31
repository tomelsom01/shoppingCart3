class PaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create], raise: false
  def index
    @purchases = current_user&.purchases
  end
  def create
    Rails.logger.info "PaymentsController#create action hit"
    @order = Order.find_by(id: params[:order_id])
    unless @order
      return redirect_to root_path, alert: "Order not found"
    end

    @amount = @order.total_price.to_f

    begin
      customer = Stripe::Customer.create(
        email: @order.email,
        source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: (@amount * 100).to_i,
        description: "Payment for Order ##{@order.id}",
        currency: 'usd'
      )

      @order.update(status: 'paid')
      redirect_to payments_path(order_id: @order.id), notice: 'Payment successful!'
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to order_path(@order)
    rescue Stripe::StripeError => e
      flash[:error] = "An error occurred with Stripe. Please try again."
      redirect_to order_path(@order)
    rescue => e
      flash[:error] = "An unexpected error occurred. Please try again."
      redirect_to order_path(@order)
    end
  end
end
