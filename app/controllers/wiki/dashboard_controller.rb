class Wiki::DashboardController < ApplicationController
  def dashboard
    @events = (recent_watched_pages_updates + recent_file_uploads).sort_by(&:created_at).reverse.first(30)
  end

  private
  def recent_watched_pages_updates
    PagePartRevision.scoped.includes(:part => {:page => :subscribers}).where(["page_part_revisions.created_at >= ?", current_user.last_dashboard_visit]).order("page_part_revisions.created_at DESC").limit(30).merge(User.scoped.where(:id => current_user.id))
  end

  def recent_file_uploads
    FileVersion.scoped.includes(:file => {:page => :subscribers}).where(["file_versions.created_at >= ?", current_user.last_dashboard_visit]).order("file_versions.created_at DESC").limit(30).merge(User.scoped.where(:id => current_user.id))
  end
end
