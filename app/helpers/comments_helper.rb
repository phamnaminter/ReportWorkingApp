module CommentsHelper
  def owner_comment comment
    comment.user_id.eql?(current_user.id) ? "text-danger" : "text-info"
  end
end
