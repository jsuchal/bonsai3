class UserSession < Authlogic::Session::Base
	verify_password_method :valid_test? if Rails.env=="development" or Rails.env=="cucumber"
end