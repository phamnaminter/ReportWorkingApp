class UsersController < ApplicationController
  authorize_resource
  before_action :paginate_users, only: :index
  before_action :find_user, except: %i(index new create)
  before_action :check_empty_pw, only: :update

  def index; end

  def show
    @pagy, @departments = pagy @user.departments,
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
      redirect_to root_path
    else
      flash.now[:danger] = t ".create_user_error"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      sign_in(@user, bypass: true)
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
    return User.sort_created_at unless params[:filter]

    @users = User.by_email(params[:filter][:email_search])
                 .by_full_name(params[:filter][:full_name_search])
                 .sort_created_at
  end

  def save_avatar
    @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
  end

  def check_empty_pw
    return unless params[:user][:password].blank? &&
                  params[:user][:password_confirmation].blank?

    params[:user].delete :password
    params[:user].delete :password_confirmation
  end
end
