class Wiki::PagesController < ApplicationController
  before_filter :find_page, :except => [:search, :quick_search]

  def history
    @revisions = @page.revisions.paginate(:page => params[:page])
  end

  def diff
    revisions = @page.revisions.find_all_by_number(params[:revisions])
    @revision_pairs = revisions.enum_cons(2)
  end

  def edit
  end

  def search
    @query = params[:q]
    @matches = current_user.search(@query).paginate(:per_page => 10)
  end

  def quick_search
    @pages = current_user.search("#{params[:term]}*", :limit => 10).collect(&:page)
  end

  private
  def find_page
    @page = Page.find_by_id(params[:id])
  end
end
