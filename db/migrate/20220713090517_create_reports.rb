class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.references :from_user, foreign_key: {to_table: :users}
      t.references :to_user, foreign_key: {to_table: :users}
      t.references :department, foreign_key: true
      t.datetime :report_date
      t.text :today_plan
      t.text :today_work
      t.text :today_problem
      t.text :tomorow_plan

      t.timestamps
    end
  end
end
