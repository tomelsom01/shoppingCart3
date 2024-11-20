class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :product, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_price
    return 0 if quantity.nil? || product.nil?
    quantity * (product.price || 0)
  end
end
