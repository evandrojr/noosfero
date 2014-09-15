class DspacePlugin::Item < Article

  settings_items :dspace_collection_id, :type => :string

  attr_accessible :dspace_collection_id

  def self.icon_name(article = nil)
    'dspace'
  end

  def self.short_description
    _("DSpace item")
  end

  def self.description
    _("Defines a item on DSpace library")
  end

  def to_html(options = {})
    dspace_item = self
    proc do
      render :file => 'content_viewer/item', :locals => {:dspace_item => dspace_item}
    end
  end

end
