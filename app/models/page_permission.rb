class PagePermission < ActiveRecord::Base
  belongs_to :page
  belongs_to :group

  scope :for_viewing, :conditions => ["page_permissions.can_view = ? OR page_permissions.can_edit = ? OR page_permissions.can_manage = ?", true, true, true]
  scope :for_editing, :conditions => ["page_permissions.can_edit = ? OR page_permissions.can_manage = ?", true, true]
  scope :for_managing, :condition => {:can_manage => true}

  scope :for_viewing!, :conditions => {:can_view => true}
  scope :for_editing!, :conditions => ["page_permissions.can_view = ? OR page_permissions.can_edit = ?", true, true]
end
