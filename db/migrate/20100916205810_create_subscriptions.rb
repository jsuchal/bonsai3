class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    rename_table :favorites, :subscriptions
  end

  def self.down
    rename_table :subscriptions, :favorites
  end
end
