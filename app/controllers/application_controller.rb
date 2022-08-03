class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  include NotifiesHelper

  before_action :set_locale, :load_notifies
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if user_signed_in?

    flash[:danger] = t "not_logged"
    store_location
    redirect_to new_user_session_path
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def require_admin
    return if current_user.admin?

    flash[:warning] = t "not_admin"
    redirect_to root_path
  end

  def require_manager department_id
    return if current_user.admin?

    relationship = current_user.relationships
                               .find_by department_id: department_id
    return if relationship&.manager?

    flash[:warning] = t "not_manager"
    redirect_to root_path
  end

  def record_not_found
    flash[:danger] = t "unavaiable_data"
    redirect_to root_path
  end

  def load_notifies
    return unless current_user

    @notifies = current_user.notifies
  end
end
