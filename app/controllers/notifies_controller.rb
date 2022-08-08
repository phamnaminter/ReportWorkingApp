class NotifiesController < ApplicationController
  authorize_resource
  before_action :find_notify, only: :show

  def show
    redirect_to @notify.link and return if @notify.read!

    flash[:danger] = t ".error_message"
    redirect_to root_path
  end

  def find_notify
    @notify = Notify.find params[:id]
  end
end
