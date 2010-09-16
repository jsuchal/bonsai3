require 'spec_helper'

describe User do
  it "should be able to watch pages" do
    User.new.can_watch?.should == true
  end
end
