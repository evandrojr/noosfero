class CkeditorContentPlugin < Noosfero::Plugin

  def self.plugin_name
    'CKEditor'
  end

  def self.plugin_description
    _("A plugin that add a new kind of text article with visual CKEditor tool.")
  end

  def stylesheet?
    false
  end

  def content_types
    [CkeditorContentPlugin::CkeditorArticle]
  end

  def js_files
    ['/javascripts/ckeditor/ckeditor.js']
  end

end
