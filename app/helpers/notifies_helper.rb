module NotifiesHelper
  def unread_class notify
    notify.unread? ? "unread" : ""
  end
end
