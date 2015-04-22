class AddSettingsToComments < ActiveRecord::Migration
  def change
    rename_column :comments, :setting, :settings
  end
end
