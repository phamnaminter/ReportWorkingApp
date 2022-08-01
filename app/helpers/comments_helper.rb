module CommentsHelper
  def owner_comment comment
    comment.user_id.eql?(current_user.id) ? "text-danger" : "text-info"
  end

  def action_comment_access? comment
    current_user.admin? || (current_user.id.eql?(comment.user_id) && @report
      .unverifyed?)
  end
end
