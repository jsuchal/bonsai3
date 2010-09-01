class Page < ActiveRecord::Base
  acts_as_nested_set
    
  belongs_to :parent, :class_name => 'Page'
  has_many :files, :class_name => 'UploadedFile'
  has_many :parts, :class_name => 'PagePart'

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
end
