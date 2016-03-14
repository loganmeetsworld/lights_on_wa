class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :except => [:line, :burst]

  helper_method :current_user
  before_action :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_last_seen_at
    current_user.update_attribute(:last_seen_at, Time.now)
  end
end
