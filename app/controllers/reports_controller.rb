class ReportsController < ApplicationController
  before_action :find_department, except: %i(show destroy)
  before_action :find_manager, except: %i(index show destroy)
  before_action :find_relationship, :paginate_reports, only: :index
  before_action :find_report, except: %i(index new create)
  before_action :check_ownership, :require_unverifyed, only: %i(update destroy)

  def index; end

  def show
    @comments = @report.comments.sort_created_at
    @comment = @report.comments.build
  end

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

  def edit; end

  def update
    if @report.update report_params
      flash[:success] = t ".edit_success_message"
      redirect_to department_reports_path(@report.department_id)
    else
      flash.now[:danger] = t ".edit_failure_message"
      render :edit
    end
  end

  def destroy
    if @report.destroy
      flash[:success] = t ".deleted_message"
    else
      flash[:danger] = t ".delete_failed_message"
    end
    redirect_to department_reports_path(@report.department_id)
  end

  def approve
    if @report.approve params[:status]
      flash[:success] = t ".update_success"
    else
      flash[:danger] = t ".update_failure"
    end
    redirect_back(fallback_location: root_path)
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
    return if current_user.admin?

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

  def check_ownership
    return if @report.from_user_id.eql? current_user.id

    flash[:warning] = t "ownership_error"
    redirect_to root_path
  end

  def require_unverifyed
    return if @report.unverifyed?

    flash[:warning] = t "unverifyed_error"
    redirect_to root_path
  end
end
