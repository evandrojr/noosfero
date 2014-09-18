class Dspace::Item < Dspace::Resource

  def self.get_all_item_metadata_from(dspace_server, item_id)
    self.site = dspace_server
    result = self.find item_id, :params => { :expand => 'metadata' }
    result.metadata
  end

end
