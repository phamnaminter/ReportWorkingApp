class ReportRemindJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform
    Department.all.each do |department|
      User.unreported_users_now(department).each do |user|
        create_notify user.id,
                      I18n.t("remind_jb_msg", department_name: department.name),
                      "/en/departments/#{department.id}"
      end
    end
  end

  def create_notify assign_uid, msg, link
    @notify = Notify.create user_id: assign_uid, msg: msg, link: link
    NotifyMailer.new_notify(@notify.id).deliver_later if @notify.save
  end
end
