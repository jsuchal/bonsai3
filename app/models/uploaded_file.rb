class UploadedFile < ActiveRecord::Base
  has_many :versions, :class_name => 'FileVersion'
  belongs_to :current_version, :class_name => 'FileVersion'
end
