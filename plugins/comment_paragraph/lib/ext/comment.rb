require_dependency 'comment'

class Comment

  scope :without_paragraph, :conditions => {:paragraph_id => nil }
  
  settings_items :comment_paragraph_selected_area, :type => :string
 
  scope :in_paragraph, proc { |paragraph_id| {
      :conditions => ['paragraph_id = ?', paragraph_id]
    }
  }

  attr_accessible :paragraph_id, :comment_paragraph_selected_area, :id

end
