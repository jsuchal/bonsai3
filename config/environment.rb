# Load the rails application
require File.expand_path('../application', __FILE__)

require 'diff/simple_diff'
require 'extras/maruku_to_s_fix'
require 'ldap/simple_ldap'

# Initialize the rails application
Bonsai3::Application.initialize!
