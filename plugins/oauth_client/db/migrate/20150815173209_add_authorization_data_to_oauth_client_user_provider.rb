class AddAuthorizationDataToOauthClientUserProvider < ActiveRecord::Migration

  def change
    rename_table :oauth_client_plugin_user_providers, :oauth_client_plugin_auths

    add_column :oauth_client_plugin_auths, :type, :string
    add_column :oauth_client_plugin_auths, :provider_user_id, :string
    add_column :oauth_client_plugin_auths, :access_token, :text
    add_column :oauth_client_plugin_auths, :expires_at, :datetime
    add_column :oauth_client_plugin_auths, :scope, :text
    add_column :oauth_client_plugin_auths, :data, :text, default: {}.to_yaml

    add_column :oauth_client_plugin_auths, :profile_id, :integer
    OauthClientPlugin::Auth.find_each batch_size: 50 do |auth|
      user = User.find_by_id(auth.user_id)
      if user.present?
        auth.profile = user.person
        auth.save!
      end
    end
    remove_column :oauth_client_plugin_auths, :user_id

    add_index :oauth_client_plugin_auths, :profile_id
    add_index :oauth_client_plugin_auths, :provider_id
    add_index :oauth_client_plugin_auths, :provider_user_id
    add_index :oauth_client_plugin_auths, :type
  end

end
