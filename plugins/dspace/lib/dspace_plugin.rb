class DspacePlugin < Noosfero::Plugin

  def self.plugin_name
      "DSpace Plugin"
  end

  def self.plugin_description
    _("A plugin that add a DSpace library feature to noosfero.")
  end

  def self.extra_blocks
    { DspacePlugin::DspaceBlock => {:type => ['community', 'profile'] } }
  end

  def stylesheet?
    true
  end

  def self.has_admin_url?
    false
  end

end
