class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  def add_product(product)
    item = cart_items.find_by(product_id: product.id)
    if item
      item.quantity += 1
    else
      item = cart_items.build(product_id: product.id, quantity: 1)
    end
    item.save
  end

  def sub_total
    cart_items.sum { |item| item.total_price }
  end
end
