require 'thinking_sphinx/test'
ThinkingSphinx::Test.init

When /^indexes are updated$/ do
  # Update all indexes
  ThinkingSphinx::Test.index
  sleep(1.0) # Wait for Sphinx to catch up
end


When /^I search for "([^"]*)"$/ do |text|
  fill_in('q', :with => text)
  click_button('Search')
end