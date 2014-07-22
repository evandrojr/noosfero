class EnvironmentDesignController < BoxOrganizerController

  protect 'edit_environment_design', :environment

  def available_blocks
    # TODO EnvironmentStatisticsBlock is DEPRECATED and will be removed from
    #      the Noosfero core soon, see ActionItem3045
    @blocks ||= [ ArticleBlock, LoginBlock, EnvironmentStatisticsBlock, RecentDocumentsBlock, EnterprisesBlock, CommunitiesBlock, SellersSearchBlock, LinkListBlock, FeedReaderBlock, SlideshowBlock, HighlightsBlock, FeaturedProductsBlock, CategoriesBlock, RawHTMLBlock, TagsBlock ]
    @blocks += plugins.dispatch(:extra_blocks, :type => Environment)
  end

  def index
    available_blocks
  end

end
