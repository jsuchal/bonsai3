class Wiki::UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = I18n.t("flash_messages.user_session.login_successful")
    end
  	redirect_back_or_default root_path
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = I18n.t("flash_messages.user_session.logout_successful")
    redirect_back_or_default root_path
	end
end