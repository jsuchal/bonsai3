class PagePartRevision < ActiveRecord::Base
  belongs_to :part, :class_name => 'PagePart'
  belongs_to :author, :class_name => 'User'

  include ActionView::Helpers::SanitizeHelper
  before_save :populate_body_without_markup, :set_revision_number

  def difference_from(second)
    SimpleDiff.diff(self.body, second.body)
  end

  private
  def populate_body_without_markup
    begin
      self.body_without_markup = Maruku.new(strip_tags(body)).children.collect(&:to_s).join(' ')
    rescue NoMethodError
      # Maruku sometimes throws a weird error
    end
	end

	def set_revision_number
		self.number = self.part.revisions.count + 1
	end
end
