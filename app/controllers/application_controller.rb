class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  helper_method :current_user

  private
  def authenticate
    @current_user = User.first
  end

  def current_user
    @current_user
  end
end
