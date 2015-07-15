class AddOAuthAuthFieldsToUserProvider < ActiveRecord::Migration

  def self.up
    change_table :oauth_client_plugin_user_providers do |t|
      t.string :token
      t.boolean :expires
      t.datetime :expiration_date
    end
  end

  def self.down
    remove_column :oauth_client_plugin_user_providers, :token
    remove_column :oauth_client_plugin_user_providers, :expires
    remove_column :oauth_client_plugin_user_providers, :expiration_date
  end
end
