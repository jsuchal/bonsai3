class PagePermission < ActiveRecord::Base
  ROLES = [:manager, :editor, :viewer]

  belongs_to :page
  belongs_to :group

  scope :for_viewing, :conditions => ["page_permissions.can_view = ? OR page_permissions.can_edit = ? OR page_permissions.can_manage = ?", true, true, true]
  scope :for_editing, :conditions => ["page_permissions.can_edit = ? OR page_permissions.can_manage = ?", true, true]
  scope :for_managing, :conditions => {:can_manage => true}

  scope :for_viewing!, :conditions => {:can_view => true}
  scope :for_editing!, :conditions => ["page_permissions.can_view = ? OR page_permissions.can_edit = ?", true, true]

  def role
    return :manager if can_manage?
    return :editor if can_edit?
    :viewer
  end

  def role=(role)
    case role
      when "manager"
        self.can_manage = true
        self.can_edit = false
        self.can_view = false
      when "editor"
        self.can_manage = false
        self.can_edit = true
        self.can_view = false
      when "viewer"
        self.can_manage = false
        self.can_edit = false
        self.can_view = true
    end
  end
end
