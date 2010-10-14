class Wiki::PagesController < ApplicationController
  before_filter :find_page, :except => [:search, :quick_search]
  before_filter :set_layouts, :only => [:edit] #TODO also for create page
  def history
    @title = "History for #{@page.title}"
    # TODO add file changes to history?
    @revisions = @page.revisions.includes(:part, :author).paginate(:page => params[:page])
  end

  def diff
    revisions = @page.revisions.find_all_by_number(params[:revisions])
    @revision_pairs = revisions.enum_cons(2)
  end

  def new

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

    def set_layouts
      @layout = @page.layout

      if @layout.nil?  #vrati default alebo zdedeny layout
        @parent_layout = @page.resolve_layout
        #@parent_layout = (inherited_layout == 'default') ? nil : inherited_layout
      else
        #vrati nil alebo zdedeny layout
        @parent_layout = @page.parent_layout
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
      directories =  Array.new
      Dir.glob("vendor/layouts/*") do |directory|
        if File::directory? directory
          if File.exist? ("#{directory}/definition.yml")
            directories.push directory
          end
        end
      end
      return directories
    end

    def get_layout_parameters(file)
      layout = YAML.load_file("#{file}/definition.yml")
      unless layout.nil?
        layout_value = file[(file.rindex("/")+1)..-1]
        parameters =[ layout_value, layout['name'], layout['parts'] ]
      end
      return parameters
    end

    def refresh_subscription
      current_user.watched_pages(true)
      render :action => :refresh_subscription
    end
end
