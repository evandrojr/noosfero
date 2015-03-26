require_dependency 'article'

class Article

  has_many :paragraph_comments, :class_name => 'Comment', :foreign_key => 'source_id', :dependent => :destroy, :order => 'created_at asc', :conditions => [ 'paragraph_uuid IS NOT NULL']

  before_save :comment_paragraph_plugin_parse_html

  settings_items :comment_paragraph_plugin_activate, :type => :boolean, :default => false

  def comment_paragraph_plugin_enabled?
    environment.plugin_enabled?(CommentParagraphPlugin) && self.kind_of?(TextArticle)
  end

  def comment_paragraph_plugin_activated?
    comment_paragraph_plugin_activate && comment_paragraph_plugin_enabled?
  end

  protected

  def comment_paragraph_plugin_parse_html
    comment_paragraph_plugin_set_initial_value unless persisted?
    return unless comment_paragraph_plugin_activated?
    if body && (body_changed? || setting_changed?(:comment_paragraph_plugin_activate))
      updated = body_changed? ? body_change[1] : body
      doc =  Nokogiri::HTML(updated)
      doc.css('body > div, body > span, body > p, li').each do |paragraph|
        next if paragraph.css('[data-macro="comment_paragraph_plugin/allow_comment"]').present? || paragraph.content.blank?

        commentable = Nokogiri::XML::Node.new("span", doc)
        commentable['class'] = "macro article_comments paragraph_comment #{paragraph['class']}"
        commentable['data-macro'] = 'comment_paragraph_plugin/allow_comment'
        commentable['data-macro-paragraph_uuid'] = SecureRandom.uuid
        commentable.inner_html = paragraph.content
        paragraph.inner_html = commentable
      end
      self.body = doc.at('body').inner_html
    end
  end

  def comment_paragraph_plugin_set_initial_value
    self.comment_paragraph_plugin_activate = comment_paragraph_plugin_enabled? &&
      comment_paragraph_plugin_settings.activation_mode == 'auto'
  end

  def comment_paragraph_plugin_settings
    @comment_paragraph_plugin_settings ||= Noosfero::Plugin::Settings.new(environment, CommentParagraphPlugin)
  end

end
