class DspacePlugin::Communityy < Article

  settings_items :dspace_community_id, :type => :string

  attr_accessible :dspace_community_id

  def self.icon_name(article = nil)
    'dspace'
  end

  def self.short_description
    _("Community")
  end

  def self.description
    _("Defines a community on DSpace library")
  end

  def to_html(options = {})
    dspace_community = self
    proc do
      render :file => 'content_viewer/community', :locals => {:dspace_community => dspace_community}
    end
  end

  def collections(dspace_server, community_id)
    Dspace::Community.get_all_collections_from dspace_server, community_id
  end

end
