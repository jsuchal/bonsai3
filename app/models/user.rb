class User < ActiveRecord::Base
  include AbstractUser

	acts_as_authentic do |c|
		c.login_field = "username"
		c.validate_password_field = false
    c.validate_login_field = false
	end

  has_many :subscriptions, :dependent => :delete_all
  has_many :watched_pages, :through => :subscriptions, :source => :page, :uniq => true

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

  private
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

	def valid_test?(password_plaintext)
		self.username == password_plaintext
		user = User.find_or_create_by_username(:username => params[:username], :name => "xstudent")
	end

end
