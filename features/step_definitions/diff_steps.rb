Given /^that a "(.*) page with multiple revisions exist$/ do |page|
  user = User.create(:name => 'wikiuser', :username => 'wikiuser')
  page = Page.create!(:title => "test", :sid=> "test")
  
  page_part = page.parts.create(:name => "body", :current_revision_id => 0)
  page_part.revisions.create(:author => user, :body => 'This is first revision', :number => 1)
  page_part.current_revision = page_part.revisions.create(:author => user, :body => 'This is second revision', :number => 2)

  page_part.save!
end