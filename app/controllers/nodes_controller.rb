class NodesController < ApplicationController
  def handle
    path = params[:path].split('/')
    @node = Node.find_by_path(path)
    # TODO check if exists
    # TODO check permissions
    send @node.controller_action
  end

  def page
    uri = request.fullpath
    redirect_to uri + '/' and return unless uri.ends_with?('/')

    @page = @node
    @title = @page.self_and_ancestors.reverse.collect(&:title).join(' | ')
    render :action => :page
  end

  def file
    @file = @node
    version = params[:version].blank? ? @file.current_version : @file.versions.find_by_version(params[:version])
    filename = params[:version].blank? ? @file.filename : version.filename_with_version
    send_file version.local_path, :filename => filename, :type => version.content_type, :disposition => 'inline'
  end
end
