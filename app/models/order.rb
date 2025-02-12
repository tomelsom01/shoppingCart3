class Order < ApplicationRecord
  belongs_to :cart
  belongs_to :user
  has_many :cart_items, through: :cart
  has_many :products, through: :cart_items

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true

  def calculate_total_price
    cart.cart_items.sum { |item| item.product.price * item.quantity }
  end

  def set_total_price
    self.total_price = calculate_total_price
  end

  before_save :set_total_price
end
