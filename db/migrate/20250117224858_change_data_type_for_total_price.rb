class ChangeDataTypeForTotalPrice < ActiveRecord::Migration[6.1]
  def up
    change_column :orders, :total_price, 'decimal USING CAST(total_price AS decimal(10,2))'
  end

  def down
    change_column :orders, :total_price, :string
  end
end
