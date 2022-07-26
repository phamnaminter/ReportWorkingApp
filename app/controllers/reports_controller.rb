class ReportsController < ApplicationController
  before_action :find_department, :find_manager, :check_access,
                only: %i(new create)

  def new
    @report = Report.new
  end

  def create
    @report = @department.reports.build report_params
                                 .merge from_user_id: current_user.id
    if @report.save
      flash[:success] = t ".create_report_message"
      redirect_to root_path
    else
      flash.now[:danger] = t ".create_report_error"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit Report::UPDATEABLE_ATTRS
  end

  def find_department
    @department = Department.find params[:department_id]
  end

  def find_manager
    @managers = Relationship.department_managers @department.id
    return if @managers.present?

    flash[:warning] = t "unprepared_manager"
    redirect_to root_path
  end

  def check_access
    return if current_user.relationships.find_by department_id: @department.id

    flash[:warning] = t "access_denied"
    redirect_to root_path
  end
end
