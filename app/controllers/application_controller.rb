class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user
  helper_method :current_user

	def require_no_user
		unless current_user.class == AnonymousUser
			store_location
			redirect_back_or_default
		end
	end

	def store_location
		session[:return_to] = request.referer
	end

	def redirect_back_or_default(default=root_path)
		redirect_to(session[:return_to] || default)
		session[:return_to] = nil
	end

	def current_user
    return @current_user if defined?(@current_user) and !@current_user.is_a?(AnonymousUser)
		if session[:user_id].nil? and not cookies[:token].nil?
      user_from_token = User.find_by_token(cookies[:token])
      session[:user_id] = user_from_token.id unless user_from_token.nil?
		end
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
		@current_user = AnonymousUser.new if @current_user.nil?
		@current_user
	end
end
