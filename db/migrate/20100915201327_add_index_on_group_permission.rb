class AddIndexOnGroupPermission < ActiveRecord::Migration
  def self.up
    add_index :group_permissions, [:user_id, :group_id], :unique => true
  end

  def self.down
    remove_index :group_permissions, [:user_id, :group_id]
  end
end
