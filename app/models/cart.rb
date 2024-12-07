class Cart < ApplicationRecord
  has_many :cart_items
  has_many :products, through: :cart_items
  has_one :order

  def add_product(product)
    current_item = cart_items.find_by(product: product)
    if current_item
      current_item.quantity += 1
    else
      current_item = cart_items.build(product: product, quantity: 1)
    end
    current_item.save
  end

  def sub_total
    cart_items.sum { |item| item.total_price.to_f }
  end

  alias_method :total, :sub_total
end
