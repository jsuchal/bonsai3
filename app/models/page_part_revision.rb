class PagePartRevision < ActiveRecord::Base
  belongs_to :part, :class_name => 'PagePart'
  belongs_to :author, :class_name => 'User'

  def difference_from(second)
    SimpleDiff.diff(self.body, second.body)
  end
end
