class Node
  def self.find_by_path(path)
    page = Page.find_by_path(path)
    if page.nil?
      parent_path = path.clone
      filename = parent_path.pop
      parent_page = Page.find_by_path(parent_path)
      parent_page.nil? ? nil : parent_page.files.find_by_filename(filename)
    else                
      page
    end
  end
end
