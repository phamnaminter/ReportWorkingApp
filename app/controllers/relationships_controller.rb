class RelationshipsController < ApplicationController
  before_action :find_department, only: %i(new create)
  before_action :find_user, only: :create
  before_action :find_relationship, only: %i(update destroy)
  before_action :paginate_users, only: :new
  Pagy::DEFAULT[:items] = Settings.relationship.per_page

  def new; end

  def create
    @user.join_department @department
    flash[:success] = t ".success_message"
    redirect_back(fallback_location: root_path)
  end

  def update
    if @relationship.update_role params[:role]
      flash[:success] = t ".update_success"
    else
      flash[:danger] = t ".update_failure"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if @relationship.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_failure"
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def show_error message
    flash[:danger] = message
    redirect_to root_path
  end

  def find_department
    require_manager params[:department_id]
    @department = Department.find params[:department_id]
  end

  def find_user
    @user = User.find params[:user_id]
  end

  def find_relationship
    @relationship = Relationship.find params[:id]
    require_manager @relationship.department_id
  end

  def paginate_users
    @pagy, @users = pagy filter_user.not_in_department @department.id
  end

  def filter_user
    return User.all unless params[:filter]

    @users = User.by_email(params[:filter][:email_search])
                 .by_full_name(params[:filter][:full_name_search])
  end
end
