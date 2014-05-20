class AddSettingToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :setting, :text
  end

  def self.down
    remove_column :comments, :setting
  end
end
