class RenameTokenToPersistenceTokenInUsers < ActiveRecord::Migration
  def self.up
		rename_column :users, :token, :persistence_token
  end

  def self.down
		rename_column :users, :persistence_token, :token
  end
end
