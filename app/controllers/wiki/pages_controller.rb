class Wiki::PagesController < ApplicationController
  before_filter :find_page, :except => [:search, :quick_search]

  def history
    @title = "History for #{@page.title}"
    # TODO add file changes to history?
    @revisions = @page.revisions.includes(:part, :author).paginate(:page => params[:page])
  end

  def diff
    revisions = @page.revisions.find_all_by_number(params[:revisions])
    @revision_pairs = revisions.enum_cons(2)
  end

  def edit
    # TODO paginate?
    @files = @page.files.order("id DESC").limit(10)
  end

  def search
    @query = params[:q]
    @matches = current_user.search(@query, :page => params[:page])
  end

  def quick_search
    @term = params[:term]
    @phrases = params[:term].split(/ +/)
    @matches = current_user.search("#{params[:term]}*", :limit => 5)
  end

  def watch
    current_user.watched_pages.push(@page)
    refresh_subscription
  end

  def unwatch
    current_user.watched_pages.delete(@page)
    refresh_subscription
  end

  private
  def find_page
    @page = Page.find_by_id(params[:id])
  end

  def refresh_subscription
    current_user.watched_pages(true)
    render :action => :refresh_subscription
  end
end
