module RelationshipsHelper
  def get_relationship user, department
    user.relationships.find_by department_id: department.id
  end

  def show_role_name user, department
    get_relationship(user, department).role_type
  end

  def user_manager? user, department
    get_relationship(user, department)&.manager?
  end

  def employee? user, department
    get_relationship(user, department)&.employee?
  end
end
