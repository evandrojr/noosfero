class DspacePlugin::Collection < Article

  settings_items :dspace_collection_id, :type => :string
  settings_items :dspace_community_id, :type => :integer

  attr_accessible :dspace_collection_id, :dspace_community_id

  def self.icon_name(article = nil)
    'dspace-collection'
  end

  def self.short_description
    _("DSpace collection")
  end

  def self.description
    _("Defines a DSpace collection")
  end

  def to_html(options = {})
    dspace_collection = self
    proc do
      render :file => 'content_viewer/collection', :locals => {:dspace_collection => dspace_collection}
    end
  end

  def items(dspace_server, collection_id)
    Dspace::Collection.get_all_items_from dspace_server, collection_id
  end

end
