class DspacePluginMyprofileController < CmsController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def new

    @success_back_to = params[:success_back_to]

    @parent = profile.articles.find(params[:parent_id]) if params && params[:parent_id]
    record_coming
    @type = params[:type]
    if @type.blank?
      @article_types = []
      available_article_types.each do |type|
        @article_types.push({
          :class => type,
          :short_description => type.short_description,
          :description => type.description
        })
      end
      @parent_id = params[:parent_id]
      render :action => 'select_article_type', :layout => false, :back_to => @back_to
      return
    else
      refuse_blocks
    end

    raise "Invalid article type #{@type}" unless valid_article_type?(@type)

    klass = @type.constantize
    article_data = environment.enabled?('articles_dont_accept_comments_by_default') ? { :accept_comments => false } : {}
    article_data.merge!(params[:article]) if params[:article]

    if @type == 'DspacePlugin::Collection'
      ids_list = 'dspace_collections_ids'
      names_list = 'dspace_collections_names'
    elsif @type == 'DspacePlugin::Communityy'
      ids_list = 'dspace_communities_ids'
      names_list = 'dspace_communities_names'
    end

    index = -1

    article_data[ids_list].each do |id|

      index += 1

      name = article_data[names_list][index]

      entity = klass.new

      parent = check_parent(params[:parent_id])

      if parent
        entity.parent = parent
        parent_id = parent.id
      end

      entity.dspace_community_id = id if @type == 'DspacePlugin::Communityy'

      if @type == 'DspacePlugin::Collection'
        entity.dspace_collection_id = id
        entity.dspace_community_id = article_data['dspace_community_id']
      end

      entity.profile = profile
      entity.author = user
      entity.last_changed_by = user
      entity.created_by = user
      entity.name = name

      entity.save!

    end

    redirect_to @parent.view_url

  end

end
