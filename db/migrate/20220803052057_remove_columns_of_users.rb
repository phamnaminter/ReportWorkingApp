class RemoveColumnsOfUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :email, :string
    remove_column :users, :password_digest, :string
    remove_column :users, :activation_digest, :string
    remove_column :users, :activation, :boolean
    remove_column :users, :activation_at, :datetime
    remove_column :users, :reset_digest, :string
    remove_column :users, :reset_sent_at, :datetime
    remove_column :users, :remember_digest, :string
  end
end
