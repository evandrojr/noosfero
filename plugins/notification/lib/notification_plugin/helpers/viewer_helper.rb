module NotificationPlugin::Helpers::ViewerHelper

  def lobby_notes_plugin_stylesheet
    plugin_stylesheet_path = NotificationPlugin.public_path('style.css')
    stylesheet_link_tag  plugin_stylesheet_path, :cache => "cache/plugins-#{Digest::MD5.hexdigest plugin_stylesheet_path.to_s}"
  end

end
