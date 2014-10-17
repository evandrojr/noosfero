module CommentParagraphPlugin::CommentParagraphHelper

  def self.auto_marking_enabled?(plugin_settings, article_type)
    auto_marking_setting = plugin_settings.get_setting('article_types_with_auto_marking')
    auto_marking_setting.include?(article_type) ? true : false
  end

end
