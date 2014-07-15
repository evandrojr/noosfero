class AddParagraphIdToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :paragraph_id, :integer
  end

  def self.down
    remove_column :comments, :paragraph_id
  end
end
