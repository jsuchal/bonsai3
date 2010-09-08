class Wiki::PagesController < ApplicationController
  before_filter :find_page

  def history
    @revisions = @page.revisions.paginate(:page => params[:page])
  end

  def diff
    revisions = @page.revisions.find_all_by_number(params[:revisions])
    @revision_pairs = revisions.enum_cons(2)
  end

  def edit
  end

  private
  def find_page
    @page = Page.find_by_id(params[:id])
  end
end
