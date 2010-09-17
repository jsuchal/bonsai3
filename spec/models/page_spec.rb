require 'spec_helper'

describe Page do
  context "when resolving path" do
    it "should find root page" do
      root = Factory.create(:page)
      Page.find_by_path([]).should == root
    end

    it "should find nested page" do
      root = Factory.create(:page)
      child = root.children.create(Factory.attributes_for(:page, :sid => 'a-page'))
      Page.find_by_path(['a-page']).should == child
    end

    it "should find even more nested page" do
      root = Factory.create(:page)
      child = root.children.create(Factory.attributes_for(:page, :sid => 'a-page'))
      nested = child.children.create(Factory.attributes_for(:page, :sid => 'nested'))
      uber_nested = nested.children.create(Factory.attributes_for(:page, :sid => 'uber-nested'))
      Page.find_by_path(['a-page','nested', 'uber-nested']).should == uber_nested
    end

    it "should return nil when there is no page on path" do
      root = Factory.create(:page)
      Page.find_by_path(['a-page']).should == nil
    end
  end

  context "when returning path" do
    it "should work for root page" do
      root = Factory.create(:page)
      root.path.should == ""
    end

    it "should work for nested page" do
      root = Factory.create(:page)
      child = root.children.create(Factory.attributes_for(:page, :sid => 'a-page'))
      child.path.should == "a-page"
    end

    it "should work for even more nested page" do
      root = Factory.create(:page)
      child = root.children.create(Factory.attributes_for(:page, :sid => 'a-page'))
      nested = child.children.create(Factory.attributes_for(:page, :sid => 'nested'))
      uber_nested = nested.children.create(Factory.attributes_for(:page, :sid => 'uber-nested'))
      uber_nested.path.should == "a-page/nested/uber-nested"
    end
  end

  context "when checking permissions" do
    it "should be viewable by everyone when no explicit view permission is given" do
      page = Factory.create(:page)
      user = Factory.create(:user)
      page.is_viewable_by_everyone?.should == true
      page.is_viewable_by?(user).should == true
    end

    it "should not be viewable by everyone when explicit view permission is given" do
      page = Factory.create(:page)
      user = Factory.create(:user)
      another_user = Factory.create(:user)
      page.permissions.create(:group => user.private_group, :can_view => 1)
      page.is_viewable_by_everyone?.should == false
      page.is_viewable_by?(user).should == true
      page.is_viewable_by?(another_user).should == false
    end

    it "should not be viewable by everyone when explicit view permission is given on parent" do
      root = Factory.create(:page)
      child = root.children.create(Factory.attributes_for(:page, :sid => 'a-page'))
      user = Factory.create(:user)
      root.permissions.create(:group => user.private_group, :can_view => 1)
      child.is_viewable_by_everyone?.should == false
    end

    it "should be viewable by user inheriting permissions from parent page" do
      root = Factory.create(:page)
      child = root.children.create(Factory.attributes_for(:page, :sid => 'a-page'))
      user = Factory.create(:user)
      root.permissions.create(:group => user.private_group, :can_view => 1)
      child.is_viewable_by?(user).should == true
    end
  end

  context "when uploading files" do
    it "should be able to create new file" do
      page = Factory.create(:page)
      user = Factory.create(:user)
      upload = Object.new
      upload.stub!(:original_filename => 'readme.txt')
      upload.stub!(:content_type => 'text/plain')
      upload.stub!(:local_path => File.dirname(__FILE__) + '/fixtures/uploaded.tmp')
      file = page.files.create_from_upload_and_uploader(upload, user)
      file.filename.should == "readme.txt"
      file.current_version.version.should == 1
      File.read(file.local_path).should == 'test'
    end

    it "should be able to update file with new revision " do
      page = Factory.create(:page)
      user = Factory.create(:user)
      upload = Object.new
      upload.stub!(:original_filename => 'readme.txt')
      upload.stub!(:content_type => 'text/plain')
      upload.stub!(:local_path => File.dirname(__FILE__) + '/fixtures/uploaded.tmp')
      page.files.create_from_upload_and_uploader(upload, user)
      another_file = page.files.create_from_upload_and_uploader(upload, user)
      another_file.current_version.version.should == 2
    end
  end
end
