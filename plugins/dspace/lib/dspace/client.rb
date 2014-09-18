class Dspace::Client

  def initialize(server_url)
    @server_url = server_url
  end

  def get_collections
    Dspace::Collection.get_all_collections_from @server_url
  end

  def get_communities
    Dspace::Community.find(:all)
  end

end

