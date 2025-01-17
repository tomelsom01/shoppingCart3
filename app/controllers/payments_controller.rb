class PaymentsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])
    @amount = @order.total_price.to_f  # Convert to float

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: (@amount * 100).to_i,  # Convert to cents and then to integer
      description: "Payment for Order ##{@order.id}",
      currency: 'usd'
    )

    @order.update(status: 'paid')  # Update status instead of 'paid' boolean
    redirect_to order_path(@order), notice: 'Payment successful!'

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to order_path(@order)
  end
end
