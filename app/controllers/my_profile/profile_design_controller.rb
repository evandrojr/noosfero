class ProfileDesignController < BoxOrganizerController

  needs_profile

  protect 'edit_profile_design', :profile

  before_filter :protect_fixed_block, :only => [:save, :move_block]

  def protect_fixed_block
    block = boxes_holder.blocks.find(params[:id].gsub(/^block-/, ''))
    if !block.nil? && block.fixed && !current_person.is_admin?
      render_access_denied
    end
  end

  def available_blocks
    @available_blocks = [ ArticleBlock, TagsBlock, RecentDocumentsBlock, ProfileInfoBlock, LinkListBlock, MyNetworkBlock, FeedReaderBlock, ProfileImageBlock, LocationBlock, SlideshowBlock, ProfileSearchBlock, HighlightsBlock ]
    @available_blocks += plugins.dispatch(:extra_blocks)

    # blocks exclusive to people
    if profile.person?
      @available_blocks << FavoriteEnterprisesBlock
      @available_blocks << CommunitiesBlock
      @available_blocks << EnterprisesBlock
      @available_blocks += plugins.dispatch(:extra_blocks, :type => Person)
    end

    # blocks exclusive to communities
    if profile.community?
      @available_blocks += plugins.dispatch(:extra_blocks, :type => Community)
    end

    # blocks exclusive for enterprises
    if profile.enterprise?
      @available_blocks << DisabledEnterpriseMessageBlock
      @available_blocks << HighlightsBlock
      @available_blocks << ProductCategoriesBlock
      @available_blocks << FeaturedProductsBlock
      @available_blocks << FansBlock
      @available_blocks += plugins.dispatch(:extra_blocks, :type => Enterprise)
    end

    # product block exclusive for enterprises in environments that permits it
    if profile.enterprise? && profile.environment.enabled?('products_for_enterprises')
      @available_blocks << ProductsBlock
    end

    # block exclusive to profiles that have blog
    if profile.has_blog?
      @available_blocks << BlogArchivesBlock
    end

    if user.is_admin?(profile.environment)
      @available_blocks << RawHTMLBlock
    end

    @available_blocks

  end

  def index
    available_blocks
  end

end
