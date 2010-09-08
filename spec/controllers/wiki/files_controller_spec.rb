require 'spec_helper'

describe Wiki::FilesController do

  describe "GET 'history'" do
    it "should be successful" do
      get 'history'
      response.should be_success
    end
  end

end
