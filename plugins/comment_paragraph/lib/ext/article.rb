require_dependency 'article'

class Article

  has_many :paragraph_comments, :class_name => 'Comment', :foreign_key => 'source_id', :dependent => :destroy, :order => 'created_at asc', :conditions => [ 'paragraph_id IS NOT NULL']

  validate :body_change_with_comments

  def body_change_with_comments
    if body && body_changed? && !self.comments.empty?
      paragraphs_with_comments = self.comments.where("'paragraph_id' IS NOT NULL")
      errors[:base] << (N_('You are unable to change the body of the article when paragraphs are commented')) unless (paragraphs_with_comments).empty?
    end
  end
  
end

