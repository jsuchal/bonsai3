class AddIndexToPagePartRevisionNumber < ActiveRecord::Migration
  def self.up
    add_index :page_part_revisions, [:part_id, :number], :unique => true
  end

  def self.down
    remove_index :page_part_revisions, [:part_id, :number]
  end
end
