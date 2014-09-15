class Dspace::Collection < Dspace::Resource
  self.site = "http://dev.maljr.net:8080/rest/"

  def self.get_items(collection_id)
    result = self.find collection_id, :params => { :expand => 'items' }
    result.items
  end

end
