class NodesController < ApplicationController
  before_filter :load_node

  def load_node
    @path = params[:path].split('/')
    @node = Node.find_by_path(@path)
    # TODO check if file

    if @node.nil?
      flash.now[:error] = 'Page or file does not exist.'
      @new_node =  @path.last
      @path.pop
      @parent = Page.find_by_path(@path)

      render :controller => :page, :action => :create
    end
  end

  def handle
    # TODO check if exists
    # TODO check permissions
    send @node.controller_action
  end

  def page
    @page = @node
    @title = @page.self_and_ancestors.reverse.collect(&:title).join(' | ')
    layout = @page.nil? ? 'application' : @page.resolve_layout
    @stylesheet = "#{(layout == 'application') ? nil : layout}"
    render :action => :page, :layout => layout
  end

  def file
    @file = @node
    version = params[:version].blank? ? @file.current_version : @file.versions.find_by_version(params[:version])
    filename = params[:version].blank? ? @file.filename : version.filename_with_version
    send_file version.local_path, :filename => filename, :type => version.content_type, :disposition => 'inline'
  end
end
