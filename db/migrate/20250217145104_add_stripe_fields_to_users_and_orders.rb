class AddStripeFieldsToUsersAndOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :paid, :boolean, default: false
    add_column :users, :card_id, :string

    add_column :orders, :payment_status, :string
  end
end
