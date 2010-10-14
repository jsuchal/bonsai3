class Wiki::FilesController < ApplicationController
  before_filter :find_page
  before_filter :find_file, :except => :create

  def history
    @versions = @file.versions.order("id DESC").paginate(:page => params[:page])
  end

  def create
    render :nothing => true and return if params[:uploaded_file].nil?
    # TODO alert when replacing existing?
    # TODO validation?
    @file = @page.files.create_from_upload_and_uploader(params[:uploaded_file], current_user)

    return render :layout => false if params[:uploaded_file][:filename].nil?
    redirect_to "/" + @page.path + "/"
  end

  private
  def find_page
    # TODO permissions
    @page = Page.find_by_id(params[:page_id])
  end

  def find_file
    @file = @page.files.find_by_id(params[:id])
  end
end
