class Dspace::Community < Dspace::Resource

  def self.get_all_communities_from(dspace_server)
    self.site = dspace_server
    self.find(:all)
  end

  def self.get_all_collections_from(dspace_server, community_id)
    self.site = dspace_server
    result = self.find community_id, :params => { :expand => 'collections' }
    result.collections
  end

end
