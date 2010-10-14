class Wiki::PagePermissionsController < ApplicationController
  before_filter :find_page
  before_filter :find_permission, :except => :create
  # TODO check permissions

  def create
    group_names = params[:page_permission][:group_names].strip.split(/ *, */)
    groups = Group.find_all_by_name(group_names)
    role = params[:page_permission][:role]
    groups.each do |group|
      current_user.set_page_permission(@page, group, role)
    end
  end

  def update
    current_user.set_page_permission(@page, @permission.group, params[:page_permission][:role])
  end

  def destroy
    @permission.destroy
  end

  private
  def find_page
    @page = Page.find(params[:page_id])
  end

  def find_permission
    @permission = @page.permissions.find(params[:id])
  end
end
