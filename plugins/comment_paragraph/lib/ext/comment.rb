require_dependency 'comment'

class Comment

  scope :without_paragraph, :conditions => {:paragraph_id => nil }

  scope :in_paragraph, proc { |paragraph_id| {
      :conditions => ['paragraph_id = ?', paragraph_id]
    }
  }

  attr_accessible :paragraph_id

end
