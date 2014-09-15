class DspacePlugin::Library < Blog

  settings_items :server_url, :type => :string, :default => "http://dspace.example.com/"
  settings_items :gather_option, :type => :string, :default => "collections"

  attr_accessible :server_url, :gather_option

  def self.icon_name(article = nil)
    'dspace'
  end

  def self.short_description
    _("DSpace library")
  end

  def self.description
    _("Defines a DSpace library")
  end

  def to_html(options = {})
    dspace_library = self
    proc do
      render :file => 'content_viewer/library', :locals => {:dspace_library => dspace_library}
    end
  end

  def bli
    'bli'
  end

end
