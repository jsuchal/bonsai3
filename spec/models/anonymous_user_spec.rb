require 'spec_helper'

describe AnonymousUser do
  it "should not be able to watch pages" do
    AnonymousUser.new.can_watch?.should == false
  end
end
