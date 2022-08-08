set :output, "report_cron_log.log"
set :environment, 'development'

every 1.day do
  runner "ReportRemindJob.perform_async"
end

every 1.day do
  rake "nampt:backup backup_name=#{Time.now}"
end
