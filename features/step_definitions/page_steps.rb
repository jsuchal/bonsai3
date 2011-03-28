When /^I create "([^"]*)" page$/ do |url|
  visit url
  #click_link("Page")
  fill_in('page_title', :with => 'Some title')
  click_button('Create Page')
  fill_in('Body', :with => 'Some content.')
  click_button('Update Page')
end

When /^I create "([^"]*)" page with title "([^"]*)"$/ do |url, title|
  visit url
  #click_link("Create Page")
  fill_in('page_title', :with => title)
  click_button('Create Page')
  fill_in('Body', :with => 'Some content.')
  click_button('Update Page')
end


When /^I create "([^"]*)" page with title "([^"]*)" body "([^"]*)"$/ do |url, title, body|
  visit url
  #click_link("Page")
  fill_in('page_title', :with => title)
  click_button('Create Page')
  fill_in('new_part_new_body', :with => body)
  
  click_button('Update Page')
end


When /^I create "([^"]*)" page with title "([^"]*)" body "([^"]*)" and "([^"]*)" layout$/ do |url, title, body, my_layout|
  visit url
  fill_in('page_title', :with => title)
  click_button('Create Page')

  fill_in('new_part_new_body', :with => body)
  select(my_layout, :from => 'page_layout')
  click_button('Update Page')
end


When /^I edit "([^"]*)" page with title "([^"]*)"$/ do |url, title|
  visit url
  click_link('Edit')
  fill_in('page_title', :with => title)
  click_button('Update Page')
end

When /^I edit "([^"]*)" page with body "([^"]*)"$/ do |url, body|
  visit url
  click_link('Edit')
  fill_in('Body', :with => body)
  click_button('Update Page')
end