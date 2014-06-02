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
    if context.respond_to?(:params) && context.params
      types = []
      parent_id = context.params[:parent_id]
      types << CommunityHubPlugin::Hub if context.profile.community? && !parent_id
      types
    else
       [CommunityHubPlugin::Hub]
    end
  end

  def content_remove_new(page)
    page.kind_of?(CommunityHubPlugin::Hub)
  end

end
