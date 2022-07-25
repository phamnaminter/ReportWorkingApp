class ReportsController < ApplicationController
  before_action :find_department, :find_manager, :check_access,
                only: %i(new create)
  before_action :find_relationship, :paginate_reports, only: :index
  before_action :find_report, only: :show

  def index; end

  def show; end

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

  def find_relationship
    @relationship = Relationship.find_by department_id: params[:department_id],
                                         user_id: current_user.id
    return if @relationship.present?

    flash[:warning] = t ".invalid_relationship"
    redirect_to root_path
  end

  def find_report
    @report = Report.find params[:id]
  end

  def paginate_reports
    @pagy, @reports = pagy find_all_reports, items: Settings.report.per_page
  end

  def filter_report
    filter = params[:filter]
    return @reports unless filter

    @reports = @reports.by_id(filter[:id])
                       .by_department(filter[:department])
                       .by_name(filter[:name])
                       .by_created_at(filter[:date_created])
                       .by_report_date(filter[:date_reported])
                       .sort_created_at
  end

  def find_all_reports
    @reports = if @relationship&.manager? || current_user.admin?
                 Report.for_manager params[:department_id]
               else
                 Report.for_employee current_user.id
               end
    filter_report
  end
end
