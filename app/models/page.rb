class Page < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :parent, :class_name => 'Page'
  has_many :files, :class_name => 'UploadedFile' do
    def create_from_upload_and_uploader(upload, uploader)
      file = find_or_create_by_filename(File.basename(upload.original_filename))
      file.current_version = file.versions.create(
              :content_type => upload.content_type,
              :size => File.size(upload.local_path),
              :uploader => uploader
      )
      FileUtils.mkdir_p(File.dirname(file.local_path))
      FileUtils.copy(upload.local_path, file.local_path)
      file.save
      file
    end
  end
  has_many :parts, :class_name => 'PagePart'
  has_many :revisions, :through => :parts, :order => "page_part_revisions.id DESC"
  has_many :permissions, :class_name => "PagePermission"

  def resolve_part part_name
    inherited_part = (PagePartRevision.joins(:part => :page).where(:was_deleted => false).where("page_parts.current_revision_id = page_part_revisions.id") & self_and_ancestors & PagePart.scoped.where(:name => part_name)).reverse.first
    inherited_part.try(:body)
  end

  def layout_parts
    definition = "vendor/layouts/#{resolve_layout}/definition.yml"
    if File.exist?(definition)
      layout = YAML.load_file(definition)
      unless layout.nil?
        return layout['parts']
      end
    end
  end

  def resolve_layout
    first_layout = Page.first(:conditions => ["(lft <= ? AND rgt >= ?) AND layout IS NOT NULL", self.lft, self.rgt], :order => "lft DESC")
    return (first_layout.nil?) ? 'default' : first_layout.layout
  end

  def parent_layout
    unless parent.nil?
      first_parent_layout = Page.first(:conditions => ["(lft <= ? AND rgt >= ?) AND layout IS NOT NULL", parent.lft, parent.rgt], :order => "lft DESC")
    end
    return (first_parent_layout.nil? ? nil : first_parent_layout.layout)
  end


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

  def is_viewable_by?(logged_user)
    return true if is_viewable_by_everyone?
    (all_permissions_for_user(logged_user) & PagePermission.for_viewing).exists?
  end

  def is_viewable_by_everyone?
    # no explicit view permission exists
    !(all_permissions & PagePermission.for_viewing!).exists?
  end

  def is_editable_by?(logged_user)
    return true if is_editable_by_everyone?
    (all_permissions_for_user(logged_user) & PagePermission.for_editing).exists?
  end

  def is_editable_by_everyone?
    # no explicit view or edit permission exists
    !(all_permissions & PagePermission.for_editing!).exists?
  end

  def is_manageable_by?(logged_user)
    (all_permissions_for_user(logged_user) & PagePermission.for_managing).exists?
  end

  private
  def all_permissions_for_user(logged_user)
    self_and_ancestors.joins(:permissions => {:group => {:group_permissions => :user}}) & User.scoped.where(:id => logged_user.id)
  end

  def all_permissions
    self_and_ancestors.joins(:permissions)
  end



end
