module AbstractUser
  def search(query, options = {})
    options.reverse_merge! :with => {:page_id => viewable_page_ids}
    PagePart.search(query, options)
  end

  protected
  def viewable_page_ids
    # overload this!
  end

  def public_page_ids
    Page.select("DISTINCT pages.id").having("(SELECT 1 FROM pages p2 LEFT JOIN page_permissions pp ON p2.id = pp.page_id AND pp.can_view = 1 WHERE pages.lft >= p2.lft AND pages.rgt <= p2.rgt AND pp.id IS NOT NULL LIMIT 1) IS NULL").collect(&:id)
  end
end