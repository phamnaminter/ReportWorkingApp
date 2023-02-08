class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("host_email", "test@example.com")
  layout "mailer"
end
