class PagePart < ActiveRecord::Base
  belongs_to :page
  belongs_to :current_revision, :class_name => 'PagePartRevision'
  has_many :revisions, :class_name => 'PagePartRevision', :foreign_key => :part_id, :order => "id DESC"

  define_index do
    indexes page.title
    indexes page.sid
    indexes current_revision.body_without_markup
    has :page_id
    where "was_deleted = 0"
    set_property :field_weights => {:title => 5, :sid => 3, :body_without_markup => 1}
    set_property :enable_star => 1
    set_property :min_prefix_len => 2
  end

  def search(query, options = {})
    options.reverse_merge!(:include => :page, :group_by => :page_id, :group_function => :attr, :group_clause => '@relevance DESC')
    super(query, options)
	end

	def set_current_revision(revision)
		unless revision.was_deleted?
			self.current_revision = revision
		end
	end
end
