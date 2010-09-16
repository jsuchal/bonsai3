class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  helper_method :current_user

  private
  def authenticate
    # TODO login/logout
    @current_user = User.first
  end

  protected
  def current_user
    @current_user
  end
end
