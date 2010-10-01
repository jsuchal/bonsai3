When /^I login as "([^\"]*)"$/ do |username|
  When 'I go to the home page'
  fill_in('Username', :with => username)
  fill_in('Password', :with => username)
  click_button('Log in')
end

When /^I login as "([^"]*)" using password "([^"]*)"/ do |username, password|
  When 'I go to the home page'
  fill_in('Username', :with => username)
  fill_in('Password', :with => password)
  click_button('Log in')
end