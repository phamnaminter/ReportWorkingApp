class NotifyMailer < ApplicationMailer
  def new_notify notify
    @notify = notify
    mail to: @notify.user.email, subject: t(".subject")
  end
end
