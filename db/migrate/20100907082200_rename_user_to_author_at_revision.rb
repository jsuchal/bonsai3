class RenameUserToAuthorAtRevision < ActiveRecord::Migration
  def self.up
    rename_column :page_part_revisions, :user_id, :author_id
  end

  def self.down
    rename_column :page_part_revisions, :author_id, :user_id
  end
end
