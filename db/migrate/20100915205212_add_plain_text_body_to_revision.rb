class AddPlainTextBodyToRevision < ActiveRecord::Migration
  def self.up
    add_column :page_part_revisions, :body_without_markup, :text, :after => :body, :null => false
    PagePartRevision.find_each {|revision| revision.save } # trigger populate_body_without_markup
end

  def self.down
    remove_column :page_part_revisions, :body_without_markup
  end
end
