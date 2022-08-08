class Relationship < ApplicationRecord
  UPDATEABLE_ATTRS = [department: [], user_id: []].freeze

  include CreateNotify

  belongs_to :user
  belongs_to :department

  before_create :notify

  delegate :full_name, to: :user

  enum role_type: {employee: 0, manager: 1}

  scope :department_managers, (lambda do |department_id|
    where department_id: department_id, role_type: :manager
  end)

  def update_role role
    return manager! if role.eql? Settings.role.manager

    employee! if role.eql? Settings.role.employee
  end

  private

  def notify
    create_notify user_id, I18n.t("role_department"),
                  routes.department_path(id: department.id)
  end
end
