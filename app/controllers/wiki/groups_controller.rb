class Wiki::GroupsController < ApplicationController
  def quick_search
    @term = params[:term]
    @groups = Group.includes(:users).where(["groups.name LIKE :infix OR users.name LIKE :infix OR users.username LIKE :infix", {:infix => "%#{@term}%"}]).limit(10)
  end
end
