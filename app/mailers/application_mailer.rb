class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("host_email")
  layout "mailer"
end
