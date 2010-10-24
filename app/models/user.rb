class User < ActiveRecord::Base
  include AbstractUser
  has_many :subscriptions, :dependent => :delete_all
  has_many :watched_pages, :through => :subscriptions, :source => :page, :uniq => true
  has_many :page_part_locks

  before_create :generate_unique_token
  after_create :create_private_group

  def full_name
    "#{name} (#{username})"
  end

  def logged_in?
    true
  end

  def can_watch?
    true
  end

  def watches?(page)
    watched_pages.include?(page)
  end

  def can_view?(node)
    node.is_viewable_by?(self)
  end

  def can_edit?(node)
    node.is_editable_by?(self)
  end

  def can_manage?(node)
    node.is_manageable_by?(self)
  end

  def private_group
    # TODO refactor to foreign key
    Group.find_by_name_and_usergroup(username, true)
  end

  def set_page_permission(page, group, role)
    permission = page.permissions.find_or_initialize_by_group_id(group.id)
    permission.role = role
    permission.save
    # TODO history
    permission
  end

  private
  def generate_unique_token
    self.token = ActiveSupport::SecureRandom.hex(16)
    generate_unique_token unless User.find_by_token(token).nil?
  end

  def create_private_group
    Group.create(:name => username, :usergroup => true).add_viewer(self)
  end

  protected
  def viewable_page_ids
    explicit_and_inherited = Page.select("DISTINCT pages.id").joins("JOIN pages p2 ON pages.lft >= p2.lft AND pages.rgt <= p2.rgt
        JOIN page_permissions pp ON p2.id = pp.page_id AND (pp.can_view = 1 OR pp.can_edit = 1 OR pp.can_manage = 1)
        JOIN group_permissions gp ON pp.group_id = gp.group_id").where(["gp.user_id = ?", id]).collect(&:id)
    (public_page_ids + explicit_and_inherited).uniq
  end
end
