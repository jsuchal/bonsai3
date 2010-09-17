class SetDefaultOnCurrentRevision < ActiveRecord::Migration
  def self.up
    change_column :page_parts, :current_revision_id, :integer
  end

  def self.down
    change_column :page_parts, :current_revision_id, :integer, :null => false
  end
end
