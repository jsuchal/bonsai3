class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user
	before_filter :current_user

  private
	def current_user_session
		return @current_user_session if defined?(@current_user_session)
		@current_user_session = UserSession.find
	end

	def current_user
		return @current_user if defined?(@current_user) and !@current_user.is_a?(AnonymousUser)
		@current_user = current_user_session && current_user_session.record
		@current_user = AnonymousUser.new if @current_user.nil?
	end

	def require_user
		unless current_user
			store_location
			flash[:notice] = "You must be logged in to access this page"
			redirect_to new_user_session_url
			return false
		end
	end

	def require_no_user
		unless current_user.class == AnonymousUser
			store_location
			flash[:notice] = "You must be logged out to access this page"
			redirect_back_or_default root_path
			return false
		end
	end

	def store_location
		session[:return_to] = request.fullpath
	end

	def redirect_back_or_default(default)
		redirect_to(session[:return_to] || default)
		session[:return_to] = nil
	end

end
