class PaymentsController < ApplicationController
  def create
    @order = Order.find(params[:order_id])
    @amount = @order.total_amount

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount.to_i * 100,  # Stripe expects amount in cents
      description: "Payment for Order ##{@order.id}",
      currency: 'usd'
    )

    @order.update(paid: true)
    redirect_to order_path(@order), notice: 'Payment successful!'

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to order_path(@order)
  end
end
