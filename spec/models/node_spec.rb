require 'spec_helper'

describe Node do
  context "when resolving path" do
    it "should find root node" do
      root = Page.create
      Node.find_by_path([]).should == root
    end

    it "should find nested page" do
      root = Page.create
      child = Page.create(:sid => 'a-page')
      Node.find_by_path(['a-page']).should == child
    end

    it "should find file at root" do
      root = Page.create
      file = root.files.create(:filename => "readme.txt")
      Node.find_by_path(['readme.txt']).should == file
    end
  end
end
