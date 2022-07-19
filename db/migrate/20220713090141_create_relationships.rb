class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :department, foreign_key: true
      t.string :position_description
      t.integer :role_type, default: 0

      t.timestamps
    end
  end
end
