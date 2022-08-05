class ReportsController < ApplicationController
  authorize_resource
  before_action :find_department, except: %i(destroy new index)
  before_action :paginate_reports, only: :index
  before_action :find_report, except: %i(index new create)
  before_action :check_ownership, :require_unverifyed, only: %i(update destroy)
  before_action :prepare_report, only: :create
  before_action :find_accessible_department, only: %i(new create edit)

  def index
    @filter = params[:filter]
  end

  def show
    @comments = @report.comments.sort_created_at
    @comment = @report.comments.build
  end

  def new
    @report = Report.new
    @report.comments.build
  end

  def create
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
    redirect_to root_path
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

    flash[:danger] = t "unprepared_manager"
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
                       .by_status(filter[:status])
                       .sort_created_at
  end

  def find_all_reports
    @reports = Report.accessible_by(current_ability)
                     .includes([:department, :from_user])
    filter_report
  end

  def check_ownership
    return if @report.from_user_id.eql? current_user.id

    flash[:danger] = t "ownership_error"
    redirect_to root_path
  end

  def require_unverifyed
    return if @report.unverifyed?

    flash[:danger] = t "unverifyed_error"
    redirect_to root_path
  end

  def prepare_report
    @report = @department.first.reports.build report_params
              .merge from_user_id: current_user.id
  end

  def find_accessible_department
    @departments = Department.accessible_by current_ability
  end
end
