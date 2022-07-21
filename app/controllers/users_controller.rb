class UsersController < ApplicationController
  before_action :logged_in_user

  def index
    @pagy, @users = pagy User.sort_created_at, items: Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t ".create_user_message"
      redirect_to root_url
    else
      flash.now[:danger] = t ".create_user_error"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password,
                                 :password_confirmation)
  end
end
