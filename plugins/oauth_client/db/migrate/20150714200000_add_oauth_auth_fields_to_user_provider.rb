class AddOauthAuthFieldsToUserProvider < ActiveRecord::Migration

  def self.up
    change_table :oauth_client_plugin_user_providers do |t|
      t.text :oauth_data
    end
  end

  def self.down
    remove_column :oauth_client_plugin_user_providers, :oauth_data
  end
end
