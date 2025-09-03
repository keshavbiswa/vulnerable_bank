class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  protect_from_forgery with: :exception, except: [ :api ]

  before_action :set_current_user

  private

  def set_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    @current_user = nil
  end

  def current_user
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Please log in to access this page"
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied"
    end
  end

  helper_method :current_user, :logged_in?
end
