class FileVersion < ActiveRecord::Base
  belongs_to :uploader, :class_name => 'User'
  belongs_to :file, :class_name => 'UploadedFile'
end
