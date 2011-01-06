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