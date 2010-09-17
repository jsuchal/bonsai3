class FileVersion < ActiveRecord::Base
  belongs_to :uploader, :class_name => 'User'
  belongs_to :file, :class_name => 'UploadedFile'

  before_create :set_version_number

  def local_path
    "#{Rails.root}/uploads/#{file.page.path}/#{filename_with_version}"
  end

  def filename_with_version
    extension = file.extension
    regex = Regexp.new(Regexp.escape(extension) + "$")
    file.filename.gsub(regex, "_version#{version}#{extension}")
  end

  private
  def set_version_number
    self.version = file.versions.count + 1
  end
end
