class CartsController < ApplicationController

  def show
    @cart = current_cart
    if @cart.nil?
      # Debugging output
      Rails.logger.debug "Current cart is nil!"
    end
  end

  def add_product
    @cart = current_cart
    product = Product.find(params[:id])
    item = @cart.cart_items.find_by(product_id: product.id)

    if item
      item.quantity += 1
      item.save
    else
      @cart.cart_items.build(product_id: product.id, quantity: 1).save
    end

    redirect_to cart_path(@cart)
  end

  def reduce_product
    @cart = current_cart
    product = Product.find(params[:id])
    item = @cart.cart_items.find_by(product_id: product.id)

    if item
      item.quantity -= 1
      item.save
    else
      @cart.cart_items.build(product_id: product.id, quantity: 1).save
    end

    redirect_to cart_path(@cart)
  end

  def destroy
    @cart = @current_cart
    @cart.destroy
    session[:cart_id] = nil
    redirect_to root_path
  end
end
