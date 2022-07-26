module CommentsHelper
  def manager_role? report
    current_user.admin? || user_manager?(current_user, report.department)
  end
end
