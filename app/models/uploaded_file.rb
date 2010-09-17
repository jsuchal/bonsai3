class UploadedFile < ActiveRecord::Base
  belongs_to :page
  has_many :versions, :class_name => 'FileVersion', :foreign_key => :file_id
  belongs_to :current_version, :class_name => 'FileVersion'

  def extension
    File.extname(filename)
  end

  def path
    "#{page.path}/#{filename}"
  end

  def local_path
    current_version.local_path
  end

  def controller_action
    :file
  end

  def is_viewable_by?(user)
    user.can_view?(page)
  end

  def is_viewable_by_everyone?
    page.is_viewable_by_everyone?
  end
end