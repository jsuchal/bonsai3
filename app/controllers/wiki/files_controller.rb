class Wiki::FilesController < ApplicationController
  def history
    @versions = @file.versions
  end
end
