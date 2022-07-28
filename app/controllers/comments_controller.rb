class CommentsController < ApplicationController
  before_action :find_comment_update, only: :update
  before_action :find_comment_destroy, only: :destroy

  def create
    if save_comment
      flash[:success] = t ".create_comment_message"
    else
      flash[:danger] = t ".create_comment_error"
    end
    redirect_to report_path(@comment.report_id)
  end

  def update
    @comment.update description: params[:comment_modal_text]
    respond_to do |format|
      format.html{redirect_to report_path(@comment.report_id)}
      format.js
    end
  end

  def destroy
    if @comment.destroy
      flash[:success] = t ".deleted_message"
    else
      flash[:danger] = t ".delete_failed_message"
    end
    redirect_to report_path(@comment.report_id)
  end

  private

  def comment_params
    params.require(:comment).permit Comment::UPDATEABLE_ATTRS
  end

  def save_comment
    @comment = Comment.new comment_params
               .merge(user_id: current_user.id, report_id: params[:report_id])
    @comment.save
  end

  def find_comment_update
    @comment = Comment.find params[:comment_id]
  end

  def find_comment_destroy
    @comment = Comment.find params[:id]
  end
end
