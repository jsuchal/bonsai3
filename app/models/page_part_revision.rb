class PagePartRevision < ActiveRecord::Base
  belongs_to :part, :class_name => 'PagePart'
end
