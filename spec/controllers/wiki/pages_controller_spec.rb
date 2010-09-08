require 'spec_helper'

describe Wiki::PagesController do

  describe "GET 'history'" do
    it "should be successful" do
      get 'history'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

end
