class Page < ActiveRecord::Base
  acts_as_nested_set
    
  belongs_to :parent, :class_name => 'Page'
  has_many :files, :class_name => 'UploadedFile'
  has_many :parts, :class_name => 'PagePart'
  has_many :revisions, :through => :parts, :order => "page_part_revisions.id DESC"
  has_many :permissions, :class_name => "PagePermission"

  def self.find_by_path(path)
    full_path = [nil] + path
    parent_id = current = nil
    full_path.each do |sid|
      current = find_by_parent_id_and_sid(parent_id, sid)
      return nil if current.nil?
      parent_id = current.id
    end
    current
  end

  def path
    self_and_ancestors.collect(&:sid).compact.join('/')
  end

  def controller_action
    :page
  end

  def is_viewable_by?(user)
    return true if is_viewable_by_everyone?
    (all_permissions_for_user(user) & PagePermission.for_viewing).exists?
  end

  def is_viewable_by_everyone?
    # no explicit view permission exists
    !(all_permissions & PagePermission.for_viewing!).exists?
  end

  def is_editable_by?(user)
    return true if is_editable_by_everyone?
    (all_permissions_for_user(user) & PagePermission.for_editing).exists?
  end

  def is_editable_by_everyone?
    # no explicit view or edit permission exists
    !(all_permissions & PagePermission.for_editing!).exists?
  end

  def is_manageable_by?(user)
    (all_permissions_for_user(user) & PagePermission.for_managing).exists?
  end

  private
  def all_permissions_for_user(user)
    self_and_ancestors.joins(:permissions => {:group => {:group_permissions => :user}}) & User.scoped.where(:id => user.id)
  end

  def all_permissions
    self_and_ancestors.joins(:permissions)
  end
end
