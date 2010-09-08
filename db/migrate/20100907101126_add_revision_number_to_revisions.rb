class AddRevisionNumberToRevisions < ActiveRecord::Migration
  def self.up
    add_column :page_part_revisions, :number, :integer, :null => false
    PagePart.find_each do |part|
      counter = 1
      part.revisions.reverse.each do |revision|
        revision.update_attribute(:number, counter)
        counter += 1
      end
    end
  end

  def self.down
    remove_column :page_part_revisions, :number
  end
end
