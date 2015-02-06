require_dependency 'article'

class Article

  scope :video_gallery, :conditions => ["articles.type == 'VideoGallery'"]
  
  #FIXME This should be done via hotspot
  def self.folder_types_with_video
    self.folder_types_without_video << 'VideoPlugin::VideoGallery'
  end

  #FIXME This should be done via hotspot
  class << self
    alias_method_chain :folder_types, :video
  end
  

#  def self.articles_columns
#    Article.column_names.map {|c| "articles.#{c}"} .join(",")
#  end
#
#  def self.most_accessed(owner, limit = nil)
#    conditions = owner.kind_of?(Environment) ?  ["hits > 0"] : ["profile_id = ? and hits > 0", owner.id]
#    result = Article.relevant_content.find(
#      :all,
#      :order => 'hits desc',
#      :limit => limit,
#      :conditions => conditions)
#    result.paginate({:page => 1, :per_page => limit})
#  end  
  
  def self.can_be_listed
    conditions = owner.kind_of?(Environment) ?  ["hits > 0"] : ["profile_id = ? and hits > 0", owner.id]
    result = Article.video_gallery.find(
      :all,
      :order => 'hits desc',
      :conditions => conditions)
  end
  
  
end






