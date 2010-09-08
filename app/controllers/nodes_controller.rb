class NodesController < ApplicationController
  before_filter :check_for_trailing_slash

  def handle
    path = params[:path].split('/')
    @node = Node.find_by_path(path)
    # TODO check if exists
    # TODO check permissions
    send @node.controller_action
  end

  def page
    @page = @node
    render :action => :page
  end

  def file
    @file = @node
    file_version = params[:version].blank? ? @file.current_version : @file.versions.find_by_version(params[:version])
    send_data :filename => file_version.filename_with_path, :type => file_version.content_type, :disposition => :inline
  end

  private
  def check_for_trailing_slash
    link = request.env['REQUEST_URI']
    if !link.ends_with?('/') && !link.include?(';')
      redirect_to link + '/'
    end
  end
end
