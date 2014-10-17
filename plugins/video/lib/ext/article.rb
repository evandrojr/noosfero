require_dependency 'article'

class Article

  def self.folder_types_with_video
    self.folder_types_without_video << 'VideoGallery'
  end
  
  class << self
    alias_method_chain :folder_types, :video
  end
  
end
