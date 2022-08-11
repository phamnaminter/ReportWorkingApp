class Relationship < ApplicationRecord
  UPDATEABLE_ATTRS = [department: [], user_id: []].freeze

  include CreateNotify

  belongs_to :user
  belongs_to :department

  after_create :notify

  delegate :full_name, to: :user

  enum role_type: {employee: 0, manager: 1}

  scope :department_managers, (lambda do |department_id|
    where department_id: department_id, role_type: :manager
  end)

  def update_role role
    return manager! if role.eql? Settings.role.manager

    employee! if role.eql? Settings.role.employee
  end

  def self.insert departments, users
    ActiveRecord::Base.transaction do
      departments.each do |department_id|
        next if department_id.blank?

        users.each do |user_id|
          user = User.find(user_id)
          department = Department.find(department_id)
          user.join_department department
        end
      end
    end
  end

  private

  def notify
    create_notify user_id, I18n.t("add_department",
                                  department_name: department.name),
                  routes.department_path(id: department.id)
  end
end
