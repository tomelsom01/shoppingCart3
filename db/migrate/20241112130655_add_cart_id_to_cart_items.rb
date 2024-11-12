class AddCartIdToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_items, :cart_id, :integer
  end
end
