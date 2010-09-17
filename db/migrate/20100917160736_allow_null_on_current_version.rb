class AllowNullOnCurrentVersion < ActiveRecord::Migration
  def self.up
    change_column :uploaded_files, :current_version_id, :integer, :null => true
  end

  def self.down
    change_column :uploaded_files, :current_version_id, :integer, :null => false
  end
end
