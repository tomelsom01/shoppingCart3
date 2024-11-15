class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :set_default_cart

  def set_default_cart
    session[:cart_id] ||= Cart.first.id  # Or set to a specific cart ID
  end

  def current_cart
    @current_cart ||= Cart.find_by(id: session[:cart_id]) || Cart.create.tap do |cart|
      session[:cart_id] = cart.id
    end
  end
end
