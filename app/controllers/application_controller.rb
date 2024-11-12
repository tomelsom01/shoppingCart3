class ApplicationController < ActionController::Base
  helper_method :current_cart

  def current_cart
    if session[:cart_id]
      @current_cart ||= Cart.find(session[:cart_id])
    else
      @current_cart = Cart.create
      session[:cart_id] = @current_cart.id
    end
    @current_cart
  end
end
