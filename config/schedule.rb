set :output, "report_cron_log.log"
set :environment, 'development'

every 1.day, at: "3:07 pm" do
  runner "ReportRemindJob.perform_async"
end

every 1.day, at: "4:30 pm" do
  rake "nampt:backup backup_name=#{Time.now}"
end
