class Page < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Page'
  has_many :files, :class_name => 'UploadedFile'
  has_many :parts, :class_name => 'PagePart'
end
