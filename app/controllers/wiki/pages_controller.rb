class Wiki::PagesController < ApplicationController
  before_filter :find_page, :except => [:search, :quick_search, :add_lock, :update_lock]
  before_filter :set_layouts, :only => [:edit] #TODO also for create page

  def rss
    @revisions = @page.revisions.includes(:part, :author)
  end

  def rss_tree
    @revisions = Page.viewable_page_revisions(@page, @current_user.viewable_page_ids)
  end

  def history
    @title = "History for #{@page.title}"
    # TODO add file changes to history?
    @revisions = @page.revisions.includes(:part, :author).paginate(:page => params[:page])
  end

  def diff
    revisions = @page.revisions.find_all_by_number(params[:revisions])
    @revision_pairs = revisions.enum_cons(2)
  end

  def create
    # TODO check permission
    page = Page.new(:title => params[:page][:title], :parent_id => params[:page][:parent_id], :sid => params[:page][:sid])
    unless (page.valid?)
      error_message = ""
      page.errors.each_full { |msg| error_message << msg }
      flash.now[:error] = error_message
      return render :action => :create, :controller => :node
    end
    page.save!
    page.add_manager @current_user.private_group
    page_part = page.parts.create(:name => "body", :current_revision_id => 0)

    first_revision = page_part.revisions.create(:author => @current_user, :body => '', :number => 1)
    page_part.current_revision = first_revision
    unless (first_revision.valid?)
      error_message = ""
      first_revision.errors.each_full { |msg| error_message << msg }
      flash.now[:error] = error_message
      page_part.delete
      page.delete
      # todo delete manager
      return render :action => :create, :controller => :node
    end
    if (first_revision.save)
      flash[:notice] = 'Page was successfully created. You can set up additional details'
      page_part.current_revision = first_revision
      page_part.save!
    end
    redirect_to edit_wiki_page_path(page)
  end

  def edit
    # TODO paginate?
    @files = @page.files.order("id DESC").limit(10)
    @new_part = PagePart.new
  end

  def update
    @page = Page.includes(:parts).find(params[:id])
    @num_of_new_revisions = 0
    edited_page_parts=[]
    params[:parts].each do |part_id, part_value|
      PagePartLock.delete_lock(part_id, @current_user)
      page_part = @page.parts.find(part_id)
      page_part.name = part_value[:name]

      newest_revisions = page_part.revisions.where(:part_id => part_id).first
      if (newest_revisions.id > part_value[:current_revision_id].to_i)
        @num_of_new_revisions += 1
      end

      unless page_part.current_revision.body == part_value[:body]
        revision = page_part.revisions.build(:author => @current_user, :body => part_value[:body], :summary => part_value[:summary])
        page_part.current_revision = revision
      end
      edited_page_parts << page_part
    end

    new_page_part = @page.parts.new(params[:new_part].merge(:current_revision_id => 0))

    if edited_page_parts.all?(&:valid?)

      if new_page_part.valid?
        new_page_part.save
        new_revision = new_page_part.revisions.create(:author => @current_user, :body => new_page_part.new_body, :number => 1)
        new_page_part.current_revision = new_revision
        new_page_part.save
        @num_of_new_revisions += 1
      end


      @page.update_attributes(params[:page])
      edited_page_parts.all?(&:save)

      if @num_of_new_revisions > 0 then
        flash[:notice] = t("flash_messages.pages.update.page_updated_with_new_revisions")
      else
        flash[:notice] = t("flash_messages.pages.update.successfull_update")
      end

      redirect_to page_path(@page.path)
    else
      flash[:error] = t("flash_messages.pages.update.failed_update")
      render :action => 'edit'
    end
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

  def add_lock
    @add_part_id = params[:part_id]

    @add_part_name = PagePart.find(@add_part_id).name
    @editedbyanother = PagePartLock.check_lock?(@add_part_id, @current_user)
    unless @editedbyanother then
      PagePartLock.create_lock(@add_part_id, @current_user)
    end
  end

  def update_lock
    @updated_part_id = 478 #params[:part_id]
    PagePartLock.create_lock(@updated_part_id, @current_user)
  end

  private
  def find_page
    @page = Page.find_by_id(params[:id])
  end

  def set_layouts
    # TODO refactor
    @layout = @page.layout

    if @layout.nil? #vrati default alebo zdedeny layout
      @parent_layout = @page.resolve_layout
    else
      #vrati nil alebo zdedeny layout
      @parent_layout = @page.parent ? @page.parent.resolve_layout : nil
    end

    @user_layouts = []

    #layout directories
    @definition = get_layout_definitions

    #basic layout settings
    if (@definition.length == 0)
      @user_layouts.push(['Inherit', nil]) #default layout
    else
      for file in @definition
        params = get_layout_parameters(file)

        #zobrazenie ze chcem zdedit layout od parenta
        if params[0] == 'default' and @parent_layout.nil? and not @page.parent.nil?
          option_text = 'Inherited (' + params[1] + ')'
          option_value = nil
        else
          #nulta uroven
          if (params[0] == @parent_layout and not @parent_layout.nil?)
            option_text = 'Inherited (' + params[1] + ')'
            option_value = nil
          else
            option_text = params[1]
            option_value = params[0]
          end
        end

        @user_layouts.push([option_text, option_value])
      end
    end
  end

  def get_layout_definitions
    directories = Array.new
    Dir.glob("vendor/layouts/*") do |directory|
      if File::directory? directory
        if File.exist?("#{directory}/definition.yml")
          directories.push directory
        end
      end
    end
    directories
  end

  def get_layout_parameters(path)
    layout = YAML.load_file("#{path}/definition.yml")
    unless layout.nil?
      layout_value = path[(path.rindex("/")+1)..-1]
      parameters =[layout_value, layout['name'], layout['parts']]
    end
    parameters
  end

  def refresh_subscription
    current_user.watched_pages(true)
    if request.xhr?
      render :action => :refresh_subscription
    else
      redirect_to page_path(@page.path)
    end
  end
end
