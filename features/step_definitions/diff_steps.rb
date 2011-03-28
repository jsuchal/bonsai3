When /^I compare first two revisions$/ do

  revisions = locate('#revisions_')
  p revisions[1].id

  #revisions = find('#revisions_')

  #check(revisions[1])
  #check(revisions[2])
  #click_button('Compare selected')
end

Given /^that a "(.*) page with multiple revisions exist$/ do |page|
  user = User.create(:name => 'johno', :username => 'johno')
  page = Page.create!(:title => "main")
  
  page_part = page.parts.create(:name => "body", :current_revision_id => 0)
  page_part.revisions.create(:author => admin, :body => 'This is first revision', :number => 1)
  page_part.current_revision = page_part.revisions.create(:page_part  => page_part, :author => admin, :body => 'This is second revision', :number => 2)

  page_part.save!
end