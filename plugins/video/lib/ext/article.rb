require_dependency 'article'

class Article

  #FIXME This should be done via hotspot
  def self.folder_types_with_video
    self.folder_types_without_video << 'VideoPlugin::VideoGallery'
  end

  #FIXME This should be done via hotspot
  class << self
    alias_method_chain :folder_types, :video
  end

end
