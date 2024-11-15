class CartItemsController < ApplicationController
  before_action :set_cart_item, only: [:destroy, :update_quantity]

  # DELETE /cart_items/:id
  def destroy
    @cart_item.destroy
    redirect_to cart_path(current_cart), notice: "Item removed from cart."
  end

  # POST /cart_items/:id/update_quantity
  def update_quantity
    if params[:quantity].to_i > 0
      @cart_item.update(quantity: params[:quantity].to_i)
      notice = "Quantity updated."
    else
      @cart_item.destroy
      notice = "Item removed from cart."
    end

    redirect_to cart_path(current_cart), notice: notice
  end

  private

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end
end
