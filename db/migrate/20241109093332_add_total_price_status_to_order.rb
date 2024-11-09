class AddTotalPriceStatusToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :total_price, :string
    add_column :orders, :status, :string
  end
end
