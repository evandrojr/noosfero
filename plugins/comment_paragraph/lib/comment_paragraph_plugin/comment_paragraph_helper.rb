module CommentParagraphPlugin::CommentParagraphHelper

  def auto_marking_enabled?(plugin_settings, article_type)
    auto_marking_setting = plugin_settings.get_setting('auto_marking_article_types')
    auto_marking_setting && auto_marking_setting.include?(article_type) ? true : false
  end

end
