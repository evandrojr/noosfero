class Dspace::Community < Dspace::Resource
  self.site = "http://dev.maljr.net:8080/rest/"

  def self.get_collections(community_id)
    result = self.find community_id, :params => { :expand => 'collections' }
    result.collections
  end

end
