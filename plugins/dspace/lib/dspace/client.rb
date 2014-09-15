class Dspace::Client

  def initialize(dspace_server_url)
  end

  def get_collections
    Dspace::Collection.find(:all)
  end

  def get_communities
    Dspace::Community.find(:all)
  end

end

