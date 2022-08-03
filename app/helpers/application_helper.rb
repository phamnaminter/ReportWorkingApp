module ApplicationHelper
  include Pagy::Frontend
  include ActiveLinkToHelper

  def full_title page_title = ""
    base_title = t "base_title"
    page_title.blank? ? base_title : [page_title, base_title].join(" | ")
  end

  def show_class_alert message_type
    message_type == "alert" ? "danger" : message_type
  end
end
