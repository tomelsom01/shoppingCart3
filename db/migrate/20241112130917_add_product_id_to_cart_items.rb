class AddProductIdToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_items, :product_id, :integer
  end
end
