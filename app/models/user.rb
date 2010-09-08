class User < ActiveRecord::Base
  before_create :generate_unique_token
  after_create :create_private_group

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
  def generate_unique_token
    self.token = ActiveSupport::SecureRandom.hex(16)
    generate_unique_token unless User.find_by_token(token).nil?
  end

  def create_private_group
    Group.create(:name => username, :usergroup => true).add_viewer(self)
  end
end
