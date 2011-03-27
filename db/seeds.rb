# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
admin = User.create(:username => "admin", :name => "Admin")
home_page = Page.create(:title => "Home")
page_part = home_page.parts.create(:name => "body", :current_revision_id => 0)
first_revision = page_part.revisions.create(:author => admin, :body => '', :number => 1)
page_part.current_revision = first_revision
page_part.save
