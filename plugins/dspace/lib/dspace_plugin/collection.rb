class DspacePlugin::Collection < Article

  settings_items :dspace_collection_id, :type => :string

  attr_accessible :dspace_collection_id

  def self.icon_name(article = nil)
    'dspace'
  end

  def self.short_description
    _("Collection")
  end

  def self.description
    _("Defines a collection on DSpace library")
  end

  def to_html(options = {})
    dspace_collection = self
    proc do
      render :file => 'content_viewer/collection', :locals => {:dspace_collection => dspace_collection}
    end
  end

end
