class AddReportStatusToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :report_status, :integer, default: 0
  end
end
