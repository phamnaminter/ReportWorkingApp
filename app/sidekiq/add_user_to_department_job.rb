class AddUserToDepartmentJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform departments, users, uid_perform
    create departments, users, uid_perform
  end

  def create departments, users, uid_perform
    insert departments, users
  rescue ActiveRecord::RecordNotFound
    create_notify uid_perform, t("autd_success"), nil
  else
    create_notify uid_perform, T("autd_failure"), nil
  end

  def insert departments, users
    ActiveRecord::Base.transaction do
      departments.each do |department_id|
        next if department_id.blank?

        users.each do |user_id|
          user = User.find(user_id)
          department = Department.finds(department_id)
          user.join_department department
        end
      end
    end
  end

  def create_notify assign_uid, msg, link
    @notify = Notify.create user_id: assign_uid, msg: msg, link: link
    NotifyMailer.new_notify(@notify.id).deliver_later if @notify.save
  end
end
