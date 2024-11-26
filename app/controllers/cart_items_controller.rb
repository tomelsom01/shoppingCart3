class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:destroy, :update_quantity]

  # ... existing destroy method ...

  def update_quantity
    if params[:quantity].to_i > 0
      @cart_item.update(quantity: params[:quantity].to_i)
      redirect_to cart_path(current_cart), notice: "Quantity updated."
    else
      @cart_item.destroy
      redirect_to cart_path(current_cart), notice: "Item removed from cart."
    end
  end
  def destroy
    @cart = current_cart
    cart_item = @cart.cart_items.find_by(id: params[:id])

    if cart_item
      cart_item.destroy
      flash[:notice] = 'Item was successfully removed from your cart.'
    else
      flash[:alert] = 'Item not found in your cart.'
    end

    redirect_to cart_path(@cart)
  end

  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end
end
