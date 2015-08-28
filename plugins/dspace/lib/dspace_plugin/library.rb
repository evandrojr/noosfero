class DspacePlugin::Library < Folder

  settings_items :dspace_server_url, :type => :string

  attr_accessible :dspace_server_url

  def dspace_server_url_valid

    if self.dspace_server_url.blank?
      errors.add(:dspace_server_url, _("can't be blank") )
      return
    end

    errors.add(self.dspace_server_url, _("is not a valid URL. Please correct it and resubmit.")) unless url_valid?(self.dspace_server_url)
  end

  validate :dspace_server_url_valid

  def self.icon_name(article = nil)
    'dspace-library'
  end

  def self.short_description
    _("DSpace library")
  end

  def self.description
    _("Defines a DSpace library")
  end

  def to_html(options = {})
    dspace_content = self
    proc do
      render :file => 'content_viewer/dspace_content', :locals => { :dspace_content => dspace_content }
    end
  end

  def communities
    DspacePlugin::Communityy.find(:all)
  end

  protected

  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end

end
