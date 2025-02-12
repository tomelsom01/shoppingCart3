class AddUserIdToOrders < ActiveRecord::Migration[7.0]
  def up
    # Add the column without NOT NULL constraint
    add_reference :orders, :user, foreign_key: true

    # Set a default user_id for existing records (if applicable)
    default_user = User.first # Replace with logic to select or create a default user
    Order.where(user_id: nil).update_all(user_id: default_user.id) if default_user

    # Add NOT NULL constraint after updating existing records
    change_column_null :orders, :user_id, false
  end

  def down
    remove_reference :orders, :user
  end
end
