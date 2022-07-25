class AddIndexToDepartmentsName < ActiveRecord::Migration[6.0]
  def change
    add_index :departments, :name, unique: true
  end
end
