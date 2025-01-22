class Order < ApplicationRecord
  belongs_to :cart
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :total_price, presence: true

  def total_price
    cart.cart_items.sum { |item| item.product.price * item.quantity }
  end
end
