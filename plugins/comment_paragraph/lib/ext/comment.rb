require_dependency 'comment'

class Comment

  scope :without_paragraph, :conditions => {:paragraph_id => nil }

  settings_items :comment_paragraph_selected_area, :type => :string
  settings_items :comment_paragraph_selected_content, :type => :string

  scope :in_paragraph, proc { |paragraph_id| {
      :conditions => ['paragraph_id = ?', paragraph_id]
    }
  }

  attr_accessible :paragraph_id, :comment_paragraph_selected_area, :id, :comment_paragraph_selected_content

  before_validation do |comment|
    comment.comment_paragraph_selected_area = nil if comment.comment_paragraph_selected_area.blank?
    comment.comment_paragraph_selected_content = nil if comment_paragraph_selected_content.blank?
  end

end
