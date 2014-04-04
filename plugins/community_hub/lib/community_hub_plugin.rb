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

  def js_files
    'javascripts/stream_post_form.js'
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

  #def self.extra_blocks
  #  { CommunityHubPlugin::HubBlock => {:position => 1} }
  #end

  def content_remove_new(page)
    page.kind_of?(CommunityHubPlugin::Hub)
  end

end
