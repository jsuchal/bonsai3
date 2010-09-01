require 'spec_helper'

describe Node do
  context "when resolving path" do
    it "should find root node" do
      root = Factory.create(:page)
      Node.find_by_path([]).should == root
    end

    it "should find nested page" do
      root = Factory.create(:page)
      child = root.children.create(Factory.attributes_for(:page, :sid => "a-page")) 
      Node.find_by_path(['a-page']).should == child
    end

    it "should find a file at root" do
      root = Page.create(:title => "Root page")
      file = root.files.create(Factory.attributes_for(:file, :filename => "readme.txt"))
      Node.find_by_path(['readme.txt']).should == file
    end

    it "should find nested file" do
      root = Factory.create(:page)
      nested = root.children.create(Factory.attributes_for(:page, :sid => "a-page"))
      file = nested.files.create(Factory.attributes_for(:file, :filename => "readme.txt"))
      Node.find_by_path(['a-page', 'readme.txt']).should == file      
    end

    it "should return nil on nothing found" do
      root = Factory.create(:page)
      nested = root.children.create(Factory.attributes_for(:page, :sid => "a-page"))
      Node.find_by_path(['another-page']).should == nil
      Node.find_by_path(['a-page', 'bogus-link']).should == nil
      Node.find_by_path(['completely', 'bogus-link']).should == nil
    end
  end
end
