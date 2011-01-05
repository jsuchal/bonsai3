class Page < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :parent, :class_name => 'Page'
  has_many :files, :class_name => 'UploadedFile' do
    def create_from_upload_and_uploader(upload, uploader)
      filename = upload['filename'].nil? ?  upload['file'].original_filename : upload['filename']

      file = find_or_create_by_filename(File.basename(filename))
      file.current_version = file.versions.create(
              :content_type => upload['file'].content_type,
              :size => File.size(upload['file'].local_path),
              :uploader => uploader
      )
      FileUtils.mkdir_p(File.dirname(file.local_path))
      FileUtils.copy(upload['file'].local_path, file.local_path)
      file.save
      file
    end
  end
  has_many :parts, :class_name => 'PagePart'
  has_many :revisions, :through => :parts, :order => "page_part_revisions.id DESC"
  has_many :permissions, :class_name => "PagePermission"
  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions, :source => :user

  def resolve_part part_name
    inherited_part = (PagePartRevision.scoped.joins(:part => :page).where(:was_deleted => false).where("page_parts.current_revision_id = page_part_revisions.id") & self_and_ancestors & PagePart.scoped.where(:name => part_name)).reverse.first
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
    # TODO get rid of reverse call
    self_and_ancestors.where(["layout IS NOT NULL and layout <> ''"]).reverse.first.try(:layout) || 'default'
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

  def add_viewer group
    #if self.viewer_groups.empty?
     # self.page_permissions.each do |permission|
      #  if (permission.can_edit == true || permission.can_manage == true)
       #   permission.can_view = true
       # end
        #permission.save
      #end
    #end
    permission = PagePermission.find_or_initialize_by_page_id_and_group_id(:page_id => self.id, :group_id => group.id)
    permission.can_view = true
    permission.save!
  end

  def add_manager group
    permission = PagePermission.find_or_initialize_by_page_id_and_group_id(:page_id => self.id, :group_id => group.id)
    permission.can_view = true #unless self.viewer_groups.empty?
    permission.can_edit = true #unless self.editor_groups.empty?
    permission.can_manage = true
    permission.save!
  end


  private
  def all_permissions_for_user(logged_user)
    self_and_ancestors.joins(:permissions => {:group => {:group_permissions => :user}}) & User.scoped.where(:id => logged_user.id)
  end

  def all_permissions
    self_and_ancestors.joins(:permissions)
  end
end
