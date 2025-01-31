class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :set_default_cart
  

  def set_default_cart
    session[:cart_id] ||= Cart.first&.id  # Use safe navigation to avoid NoMethodError
  end

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
end
