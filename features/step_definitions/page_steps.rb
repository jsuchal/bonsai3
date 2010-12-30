When /^I create "([^"]*)" page with title "([^"]*)" body "([^"]*)"$/ do |url, title, body|
  visit url
  click_link("Page")
  fill_in('title', :with => title)
  fill_in('body', :with => body)
  fill_in('summary', :with => "summary")
  click_button('Save')
end