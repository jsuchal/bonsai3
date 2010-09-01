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
end
