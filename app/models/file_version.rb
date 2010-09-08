class FileVersion < ActiveRecord::Base
  belongs_to :uploader, :class_name => 'User'
  belongs_to :file, :class_name => 'UploadedFile'

  def filename_with_path
    "#{Rails.root}/uploads/#{file.path}"
  end
end
