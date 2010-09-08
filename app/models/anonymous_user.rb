class AnonymousUser
  include AbstractUser

  def can_view?(node)
    node.is_viewable_by_everyone?
  end

  def can_edit?(node)
    false
  end

  def can_manage?(node)
    false
  end

  protected
  def viewable_page_ids
    public_page_ids
  end
end
