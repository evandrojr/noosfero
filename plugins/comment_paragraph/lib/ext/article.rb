require_dependency 'article'

#FIXME should be specific to TextArticle?
class Article

  has_many :paragraph_comments, :class_name => 'Comment', :foreign_key => 'source_id', :dependent => :destroy, :order => 'created_at asc', :conditions => [ 'paragraph_uuid IS NOT NULL']

  before_save :parse_html

  def parse_paragraph(paragraph_content, paragraph_uuid)
    "<div class='macro article_comments paragraph_comment' " +
      "data-macro='comment_paragraph_plugin/allow_comment' " +
      "data-macro-paragraph_uuid='#{paragraph_uuid}'>#{paragraph_content}</div>\r\n" +
      "<p>&nbsp;</p>"
  end

  def parse_html
    if body && body_changed?
      parsed_paragraphs = []
      updated = body_change[1]
      doc = Hpricot(updated)
      doc.search("/*").each do |paragraph|
        if paragraph.to_html =~ /^<div(.*)paragraph_comment(.*)$/ || paragraph.to_html =~ /^<p>\W<\/p>$/
          parsed_paragraphs << paragraph.to_html
        else
          if paragraph.to_html =~ /^(<div|<table|<p|<ul).*/
            parsed_paragraphs << parse_paragraph(paragraph.to_html, SecureRandom.uuid)
          else
            parsed_paragraphs << paragraph.to_html
          end
        end
      end
      self.body = parsed_paragraphs.join()
    end
  end

end
