require_dependency 'article'

class Article

  has_many :paragraph_comments, :class_name => 'Comment', :foreign_key => 'source_id', :dependent => :destroy, :order => 'created_at asc', :conditions => [ 'paragraph_uuid IS NOT NULL']

  before_save :comment_paragraph_plugin_parse_html

  settings_items :comment_paragraph_plugin_activate, :type => :boolean, :default => false

  def comment_paragraph_plugin_enabled?
    environment.plugin_enabled?(CommentParagraphPlugin) && self.kind_of?(TextArticle)
  end

  protected

  def comment_paragraph_plugin_activate?
      comment_paragraph_plugin_enabled? && comment_paragraph_plugin_settings.activation_mode == 'auto'
  end

  def comment_paragraph_plugin_parse_html
    comment_paragraph_plugin_activate = comment_paragraph_plugin_activate?
    return unless comment_paragraph_plugin_activate

    if body && body_changed?
      parsed_paragraphs = []
      updated = body_change[1]
      doc = Hpricot(updated)
      doc.search("/*").each do |paragraph|
        if paragraph.to_html =~ /^<div(.*)paragraph_comment(.*)$/ || paragraph.to_html =~ /^<p>\W<\/p>$/
          parsed_paragraphs << paragraph.to_html
        else
          if paragraph.to_html =~ /^(<div|<table|<p|<ul).*/
            parsed_paragraphs << comment_paragraph_plugin_parse_paragraph(paragraph.to_html, SecureRandom.uuid)
          else
            parsed_paragraphs << paragraph.to_html
          end
        end
      end
      self.body = parsed_paragraphs.join()
    end
  end

  def comment_paragraph_plugin_settings
    @comment_paragraph_plugin_settings ||= Noosfero::Plugin::Settings.new(environment, CommentParagraphPlugin)
  end

  def comment_paragraph_plugin_parse_paragraph(paragraph_content, paragraph_uuid)
    "<div class='macro article_comments paragraph_comment' " +
      "data-macro='comment_paragraph_plugin/allow_comment' " +
      "data-macro-paragraph_uuid='#{paragraph_uuid}'>#{paragraph_content}</div>\r\n" +
      "<p>&nbsp;</p>"
  end

end
