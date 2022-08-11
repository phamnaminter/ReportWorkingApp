class NotifyMailer < ApplicationMailer
  def new_notify notify_id
    @notify = Notify.find notify_id
    mail to: @notify.user.email, subject: t(".subject")
  end
end
