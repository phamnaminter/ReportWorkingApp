class UsersController < ApplicationController
  before_action :paginate_users, only: :index
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index; end

  def show
    @pagy, @departments = pagy @user.departments.includes([:avatar_attachment]),
                               items: Settings.department.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      save_avatar
      flash[:success] = t ".create_user_message"
      redirect_to root_url
    else
      flash.now[:danger] = t ".create_user_error"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".edit_success_message"
      redirect_to @user
    else
      flash.now[:danger] = t ".edit_failure_message"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".deleted_message"
    else
      flash[:danger] = t ".delete_failed_message"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit User::UPDATEABLE_ATTRS
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def paginate_users
    @pagy, @users = pagy filter_user, items: Settings.user.per_page
  end

  def filter_user
    unless params[:filter]
      return User.includes([:avatar_attachment]).sort_created_at
    end

    @users = User.by_email(params[:filter][:email_search])
                 .by_full_name(params[:filter][:full_name_search])
                 .sort_created_at
  end

  def correct_user
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def save_avatar
    @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
  end
end
