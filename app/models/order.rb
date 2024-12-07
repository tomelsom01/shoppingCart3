class Order < ApplicationRecord
  belongs_to :cart
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true

  def total_price
    # Calculate the total price based on order items
    cart.cart_items.sum { |item| item.quantity * item.product.price }
  end
end
