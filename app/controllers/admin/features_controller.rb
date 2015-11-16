class FeaturesController < AdminController

  protect 'edit_environment_features', :environment

  def index
    @features = Environment.available_features.sort_by{|k,v|v}
  end

  def manage_blocks
    @blocks = [ ArticleBlock,
                TagsBlock,
                RecentDocumentsBlock,
                ProfileInfoBlock,
                LinkListBlock,
                MyNetworkBlock,
                FeedReaderBlock,
                ProfileImageBlock,
                LocationBlock,
                SlideshowBlock,
                ProfileSearchBlock,
                HighlightsBlock,
                FriendsBlock,
                FavoriteEnterprisesBlock,
                CommunitiesBlock,
                EnterprisesBlock,
                MembersBlock,
                DisabledEnterpriseMessageBlock,
                ProductCategoriesBlock,
                FeaturedProductsBlock,
                FansBlock,
                ProductsBlock ]

    @blocks += plugins.dispatch(:extra_blocks)
    @blocks.sort_by! { |block| block.name }
  end

  post_only :update
  def update
    if @environment.update(params[:environment])
      session[:notice] = _('Features updated successfully.')
      redirect_to :action => 'index'
    else
      render :action => 'index'
    end
  end

  post_only :update_blocks
  def update_blocks
    params[:environment].delete(:available_blocks)
    if @environment.update_attributes(params[:environment])
      session[:notice] = _('Blocks updated successfully.')
      redirect_to :action => 'manage_blocks'
    else
      render :action => 'manage_blocks'
    end
  end

  def manage_fields
    @person_fields = Person.fields
    @enterprise_fields = Enterprise.fields
    @community_fields = Community.fields
  end

  def manage_person_fields
    environment.custom_person_fields = params[:person_fields]
    if environment.save!
      session[:notice] = _('Person fields updated successfully.')
    else
      flash[:error] = _('Person fields not updated successfully.')
    end
    redirect_to :action => 'manage_fields'
  end

  def manage_enterprise_fields
    environment.custom_enterprise_fields = params[:enterprise_fields]
    if environment.save!
      session[:notice] = _('Enterprise fields updated successfully.')
    else
      flash[:error] = _('Enterprise fields not updated successfully.')
    end
    redirect_to :action => 'manage_fields'
  end

  def manage_community_fields
    environment.custom_community_fields = params[:community_fields]
    if environment.save!
      session[:notice] = _('Community fields updated successfully.')
    else
      flash[:error] = _('Community fields not updated successfully.')
    end
    redirect_to :action => 'manage_fields'
  end

  def search_members
    arg = params[:q].downcase
    result = environment.people.where('LOWER(name) LIKE ? OR identifier LIKE ?', "%#{arg}%", "%#{arg}%")
    render :text => prepare_to_token_input(result).to_json
  end

end
