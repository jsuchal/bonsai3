Given /^user "(.*)" exists$/ do |username|
  User.create(:username => username, :name => username)
end

Given /^I am logged in$/ do
  When 'I go to the home page'
  And 'I login as "wikiuser"'
end

When /^I logout$/ do
  click_link('Log out')
end

Given /^I am not logged in$/ do
  if session[:user_id] != nil
    When 'I go to the home page'
    And 'I logout'
  end
end

When /^I visit RSS feed of "([^"]*)"$/ do |path|
  @path = path.split('/')
  page = Page.find_by_path(@path)

  visit rss_wiki_page_path(page)
end

When /^I visit diff between revision (.*) and (.*) of "([^"]*)"$/ do |first, second, path|
  @path = path.split('/')
  page = Page.find_by_path(@path)
  
  visit "#{diff_wiki_page_path(page)}/diff?revisions[]=#{second}&revisions[]=#{first}"
end

When /^I wait for (\d+) seconds?$/ do |secs|
  sleep secs.to_i
end


Then /^I should be redirected to the (.+?) page$/ do |page_name|
  request.headers['HTTP_REFERER'].should_not be_nil
  request.headers['HTTP_REFERER'].should_not == request.request_uri

  Then "I should be on #{page_name}"
end


Then /^I should see a link to "([^\"]*)" with text "([^\"]*)"$/ do |url, text|
    page.should have_selector("a[href='#{ url }']") do |element|
    element.should contain(text)
  end
end

Then /^"([^"]*)" should be selected for "([^"]*)"$/ do |value, field|
  field_labeled(field).element.search(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end


Then /"(.*)" should appear before "(.*)"/ do |first_example, second_example|
     response.body.should =~ /#{first_example}.*#{second_example}/m
end

When /^I submit the form "(.*)"$/ do |form_name|
  submit_form form_name
end