class Wiki::PagePartsController < ApplicationController
  def destroy
    begin
      page_part = PagePart.find(params[:id])
      current_revision = page_part.current_revision
      revision = page_part.current_revision.create(:part_id => page_part, :author => current_user, :body => current_revision.body, :summary => current_revision.summary, :was_deleted => true)
      page_part.current_revision = revision
      page_part.save
    rescue
      logger.error "Deletion of page part #{params[:id]} failed"
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
