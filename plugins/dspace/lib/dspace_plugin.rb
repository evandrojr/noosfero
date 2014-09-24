class DspacePlugin < Noosfero::Plugin

  def self.plugin_name
      "DSpace Plugin"
  end

  def self.plugin_description
    _("A plugin that add a DSpace library feature to noosfero.")
  end

  def content_types
    if context.respond_to?(:params) && context.params
      types = []
      parent_id = context.params[:parent_id]
      types << DspacePlugin::Library if context.profile.community? && !parent_id
      parent = parent_id ? context.profile.articles.find(parent_id) : nil
      if parent.kind_of?(DspacePlugin::Library)
        types << DspacePlugin::Communityy
      elsif parent.kind_of?(DspacePlugin::Communityy)
        types << DspacePlugin::Collection
      end
      types
    else
      [DspacePlugin::Library, DspacePlugin::Collection, DspacePlugin::Communityy]
    end
  end

  def stylesheet?
    true
  end

  def self.has_admin_url?
    false
  end

end
