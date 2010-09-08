class Group < ActiveRecord::Base
  has_many :group_permissions
  has_many :page_permissions
  has_many :users, :through => :group_permissions

  def add_viewer(user)
    permission = group_permissions.find_or_initialize_by_user_id(:user_id => user.id)
    permission.can_view = true
    permission.save
  end
end
