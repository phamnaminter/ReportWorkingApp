class CreateNotifies < ActiveRecord::Migration[6.0]
  def change
    create_table :notifies do |t|
      t.references :user, foreign_key: true
      t.string :msg
      t.string :link
      t.integer :read, default: 0

      t.timestamps
    end
  end
end
