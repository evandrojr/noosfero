require_dependency 'article'

class Article

  has_many :paragraph_comments, :class_name => 'Comment', :foreign_key => 'source_id', :dependent => :destroy, :order => 'created_at asc', :conditions => [ 'paragraph_id IS NOT NULL']

  validate :not_empty_paragraph_comments_removed

  def not_empty_paragraph_comments_removed
    if body && body_changed?
      paragraphs_with_comments = Comment.find(:all, :select => 'distinct paragraph_id', :conditions => {:source_id => self.id}).map(&:paragraph_id).compact
      paragraphs = Hpricot(body.to_s).search('.macro').collect{|element| element['data-macro-paragraph_id'].to_i}
      errors[:base] << (N_('Not empty paragraph comment cannot be removed')) unless (paragraphs_with_comments-paragraphs).empty?
    end
  end

end

