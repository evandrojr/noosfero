class Dspace::Client

  def initialize(dspace_server_url)
  end

  def get_collection_items(collection)
    collection_items = Dspace::Collection.find(:all)
  end

end
