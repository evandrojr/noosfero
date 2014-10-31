class DspacePlugin < Noosfero::Plugin

  def self.plugin_name
      "DSpace Plugin"
  end

  def self.plugin_description
    _("A plugin that add a DSpace library feature to noosfero.")
  end

  def content_types
    return [] if !context.kind_of?(CmsController)
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

  def cms_controller_filters
    block = proc do

      dspace_content_type = params[:type]

      case dspace_content_type

        when 'DspacePlugin::Communityy'
          parent = DspacePlugin::Library.find_by_id(params[:parent_id])
          children = Dspace::Community.get_all_communities_from parent.dspace_server_url

        when 'DspacePlugin::Collection'
          parent = DspacePlugin::Communityy.find_by_id(params[:parent_id])
          children = Dspace::Collection.get_all_collections_from parent.parent.dspace_server_url

      end

      if dspace_content_type == 'DspacePlugin::Communityy' || dspace_content_type == 'DspacePlugin::Collection'
        if children.nil?
          session[:notice] = _('Unable to contact DSpace server')
          redirect_to parent.view_url
        end
      end

    end

    { :type => 'before_filter',
      :method_name => 'new',
      :block => block }
  end

end
