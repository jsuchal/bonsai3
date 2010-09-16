require 'spec_helper'

describe PagePartRevision do
  it "should save body without markup" do
    body = <<MARKDOWN
# Heading

* bullet item with **emphasis**

<p>Test <em>html</em> filtering</p>
MARKDOWN
    revision = Factory.create(:page_part_revision, :body => body)
    revision.body_without_markup.should == "Heading bullet item with  emphasis Test html filtering"
  end
end
