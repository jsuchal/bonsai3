class Wiki::SessionsController < ApplicationController
  before_filter :store_location

  def create
    return unless params[:username] or params[:password]
    authenticator = (Rails.env == 'production') ? SimpleLDAP : SimpleLDAP::Stub

    data = authenticator.authenticate(params[:username], params[:password],
                                      Bonsai.ldap.host,
                                      Bonsai.ldap.port,
                                      Bonsai.ldap.base_dn
    )
    if data
      if data
        name = data.first.cn.to_s
      else
        name = params[:username]
      end
      #authentifikovany
      user = User.find_or_create_by_username(:username => params[:username], :name => name)
      successful_login(user)
    else
      failed_login
    end
  end

  def destroy
    flash[:notice] = t("flash_messages.wiki_session.logout_successful")

    cookies.delete :token
    session[:user_id] = nil
    session[:last_visit] = nil
    redirect_to session[:return_to]
  end

  private
  def successful_login(user)
    session[:user_id] = user.id
    cookies[:token] = {:value => user.token, :expires => 1.month.from_now}
    flash[:notice] = t("flash_messages.wiki_session.login_successful")
    redirect_to session[:return_to]
  end

  def failed_login
    flash[:error] = t("flash_messages.wiki_session.login_error")
    redirect_to session[:return_to]
  end
end