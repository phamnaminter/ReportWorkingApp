class ChartController < ApplicationController
  def index
    @users = User.all
    @reports = Report.all
    @departments = Department.all
    set_default
    create_filter
  end

  private
  def create_filter
    filter = params[:filter]
    return unless filter

    @start_date = to_time(filter[:start_date]) unless filter[:start_date].blank?
    @end_date = to_time(filter[:end_date]) unless filter[:end_date].blank?
  end

  def to_time yyyy_mm_dd
    Date.strptime(yyyy_mm_dd, "%Y-%m-%d").to_time
  end

  def set_default
    @start_date = 2.weeks.ago
    @end_date = 2.weeks.from_now
  end
end
