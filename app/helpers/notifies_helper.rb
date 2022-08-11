module NotifiesHelper
  def unread_class notify
    notify.unread? ? "unread" : ""
  end

  def create_notify assign_uid, msg, link
    @notify = Notify.create user_id: assign_uid, msg: msg, link: link
    NotifyMailer.new_notify(@notify.id).deliver_later if @notify.save
  end
end
