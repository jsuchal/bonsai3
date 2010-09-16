# Load the rails application
require File.expand_path('../application', __FILE__)

require 'diff/simple_diff'
require 'extras/maruku_to_s_fix'

# Initialize the rails application
Bonsai3::Application.initialize!
