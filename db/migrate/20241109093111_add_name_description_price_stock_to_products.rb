class AddNameDescriptionPriceStockToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :name, :string
    add_column :products, :description, :string
    add_column :products, :price, :string
    add_column :products, :stock, :string
  end
end
