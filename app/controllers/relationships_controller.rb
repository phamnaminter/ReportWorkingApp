class RelationshipsController < ApplicationController
  authorize_resource
  before_action :find_relationship, only: %i(update destroy)
  before_action :paginate_users, only: :new
  before_action :relationship_params, only: :create
  Pagy::DEFAULT[:items] = Settings.relationship.per_page

  def new
    @departments = Department.sort_created_at
    @relationship = Relationship.new
  end

  def create
    ActiveRecord::Base.transaction do
      relationship_params[:department].each do |department_id|
        next if department_id.blank?

        relationship_params[:user_id].each do |user_id|
          user = User.find(user_id)
          department = Department.find(department_id)
          user.join_department department
        end
      end
    end

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
    @pagy, @users = pagy filter_user
  end

  def filter_user
    return User.all unless params[:filter]

    @users = User.by_email(params[:filter][:email_search])
                 .by_full_name(params[:filter][:full_name_search])
  end

  def relationship_params
    params.require(:relationship).permit Relationship::UPDATEABLE_ATTRS
  end
end
