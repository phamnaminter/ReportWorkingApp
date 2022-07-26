class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :department

  enum role_type: {employee: 0, manager: 1}

  def update_role role
    return manager! if role.eql? Settings.role.manager

    employee! if role.eql? Settings.role.employee
  end
end
