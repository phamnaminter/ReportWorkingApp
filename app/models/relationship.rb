class Relationship < ApplicationRecord
  UPDATEABLE_ATTRS = [department: [], user_id: []].freeze

  belongs_to :user
  belongs_to :department

  delegate :full_name, to: :user

  enum role_type: {employee: 0, manager: 1}

  scope :department_managers, (lambda do |department_id|
    where department_id: department_id, role_type: :manager
  end)

  scope :manager, (lambda do
    where role_type: :manager
  end)

  def update_role role
    return manager! if role.eql? Settings.role.manager

    employee! if role.eql? Settings.role.employee
  end
end
