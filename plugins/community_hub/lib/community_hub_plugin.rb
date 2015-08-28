class CommunityHubPlugin < Noosfero::Plugin

  def self.plugin_name
    'Community Hub'
  end

  def self.plugin_description
    _("New kind of content for communities.")
  end

  def stylesheet?
    true
  end

  def content_types
    return [] if !context.kind_of?(CmsController)
    if context.respond_to?(:params) && context.params
      types = []
      types << CommunityHubPlugin::Hub if context.profile.community?
      types
    else
       [CommunityHubPlugin::Hub]
    end
  end

  def content_remove_new(page)
    page.kind_of?(CommunityHubPlugin::Hub)
  end

end
