require_dependency 'article'

class Article

  has_many :paragraph_comments, :class_name => 'Comment', :foreign_key => 'source_id', :dependent => :destroy, :order => 'created_at asc', :conditions => [ 'paragraph_uuid IS NOT NULL']

 # validate :body_change_with_comments
  
  before_save :parse_html

  def body_change_with_comments
    if body && body_changed? && !self.comments.empty?
      paragraphs_with_comments = self.comments.where("paragraph_uuid IS NOT NULL")
      errors[:base] << (N_('You are unable to change the body of the article when paragraphs are commented')) unless (paragraphs_with_comments).empty?
    end
  end
  
  def parse_html
    if body && body_changed? 
      parsed_paragraphs = []
      updated = body_change[1]
      doc = Hpricot(updated)
      paragraphs = doc.search("/*").each do |paragraph|
        uuid = SecureRandom.uuid
        if paragraph.to_html =~ /^<div(.*)paragraph_comment(.*)$/ || paragraph.to_html =~ /^<p>\W<\/p>$/
          parsed_paragraphs << paragraph.to_html
        else
          if paragraph.to_html =~ /^(<div|<table|<p|<ul).*/
            parsed_paragraphs << CommentParagraphPlugin.parse_paragraph(paragraph.to_html, uuid)
          else
            parsed_paragraphs << paragraph.to_html
          end
        end
      end
      self.body = parsed_paragraphs.join()
      #@article.save
    end
  end
 
 
end
