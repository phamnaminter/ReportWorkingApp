class NotifiesController < ApplicationController
  before_action :logged_in_user
  before_action :find_notify, :check_owner, only: :show

  def show
    redirect_to @notify.link and return if @notify.read!

    flash[:danger] = t ".error_message"
    redirect_to root_path
  end

  def find_notify
    @notify = Notify.find params[:id]
  end

  def check_owner
    return if current_user.id.eql? @notify.user_id

    flash[:danger] = t ".error_access"
    redirect_to root_path
  end
end
