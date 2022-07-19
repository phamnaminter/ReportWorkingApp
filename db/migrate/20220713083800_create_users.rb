class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone
      t.string :full_name
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest
      t.boolean :activation, default: false
      t.integer :role, default: 0
      t.datetime :activation_at
      t.datetime :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
  end
end
