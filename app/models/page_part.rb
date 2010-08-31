class PagePart < ActiveRecord::Base
  belongs_to :page
  belongs_to :current_revision, :class_name => 'PagePartRevision'
  has_many :revisions, :class_name => 'PagePartRevision'
end
