class HomeController < PublicController

  def index
    @has_news = false
    if environment.enabled?('use_portal_community') && environment.portal_community
      @has_news = true
      @news_cache_key = "home_page_news_#{environment.id.to_s}"
      if !read_fragment(@news_cache_key)
        portal_community = environment.portal_community
        @portal_news = portal_community.news(5)
        @highlighted_news = portal_community.news(2, true)
        @area_news = environment.portal_folders
      end
    end
  end

end
