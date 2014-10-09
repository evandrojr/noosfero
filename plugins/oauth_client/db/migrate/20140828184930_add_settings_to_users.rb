class AddSettingsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :settings, :string
  end

  def self.down
    remove_column :users, :settings
  end
end
