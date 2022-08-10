class DepartmentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :paginate_departments, only: :index
  before_action :find_department, except: %i(index new create)
  Pagy::DEFAULT[:items] = Settings.department.per_page

  def index; end

  def show
    @pagy, @users = pagy @department.users
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new department_params
    if @department.save
      save_avatar
      flash[:success] = t ".create_department_message"
      redirect_to @department
    else
      flash.now[:danger] = t ".create_department_error"
      render :new
    end
  end

  def edit; end

  def update
    if @department.update(department_params)
      flash[:success] = t ".edit_success_message"
      redirect_to @department
    else
      flash.now[:danger] = t ".edit_failure_message"
      render :edit
    end
  end

  def destroy
    if @department.destroy
      flash[:success] = t ".deleted_message"
    else
      flash[:danger] = t ".delete_failed_message"
    end
    redirect_to departments_path
  end

  private

  def department_params
    params.require(:department).permit Department::UPDATEABLE_ATTRS
  end

  def save_avatar
    avatar = params[:department][:avatar]
    @department.avatar.attach(avatar) if avatar
  end

  def paginate_departments
    @filter = Department.ransack(params[:filter])
    @pagy, @departments = pagy @filter.result
  end

  def filter_department
    return Department.sort_created_at unless params[:filter]

    @departments = @filter.ransack(params[:filter]).result(distinct: true)
  end

  def find_department
    @department = Department.find_by id: params[:id]
    return if @department

    flash[:danger] = t ".not_found"
    redirect_to root_path
  end
end
