class SimplifyForeignKeys < ActiveRecord::Migration
  def self.up
    rename_column :page_parts, :current_page_part_revision_id, :current_revision_id
    rename_column :page_part_revisions, :page_part_id, :part_id
    rename_column :uploaded_files, :current_file_version_id, :current_version_id
  end

  def self.down
    rename_column :page_parts, :current_revision_id, :current_page_part_revision_id
    rename_column :page_part_revisions, :part_id, :page_part_id
    rename_column :uploaded_files, :current_version_id, :current_file_version_id
  end
end
