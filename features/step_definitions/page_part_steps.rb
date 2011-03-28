When /^I add "([^"]*)" page part with text "([^"]*)"$/ do |part_name, text|
  click_link('Edit')
  fill_in('new_part_name', :with => part_name )
  fill_in('new_part_new_body', :with => text )
  click_button('Update Page')
end

When /^I edit "([^"]*)" page "([^"]*)" part with text "([^"]*)"$/ do |path, part_name, new_text|
  click_link('Edit')

  @path = path.split('/')
  page = Page.find_by_path(@path)

  part = PagePart.find_by_name_and_page_id(part_name,page.id)

  fill_in("parts[#{part.id}][body]", :with => new_text )
  click_button('Update Page')
end

When /^I edit "([^"]*)" page "([^"]*)" part name with "([^"]*)"$/ do |path, part_name, new_name|
  click_link('Edit')

  @path = path.split('/')
  page = Page.find_by_path(@path)

  part = PagePart.find_by_name_and_page_id(part_name,page.id)

  fill_in("parts[#{part.id}][body]", :with => new_name )
  click_button('Update Page')
end
