class DspacePlugin::Communityy < Article

  settings_items :dspace_community_id, :type => :string

  attr_accessible :dspace_community_id

  def self.icon_name(article = nil)
    'dspace-community'
  end

  def self.short_description
    _("DSpace community")
  end

  def self.description
    _("Defines a DSpace community")
  end

  def to_html(options = {})
    dspace_community = self
    proc do
      render :file => 'content_viewer/community', :locals => {:dspace_community => dspace_community}
    end
  end

  def collections(dspace_server, community_id)
    DspacePlugin::Collection.find(:all)
  end

end
