require_dependency 'article'

class Article

  before_create do |article|
  #  if article.parent.kind_of?(CommunityDashboardPlugin::Hub)
  #    article.accept_comments = article.parent.accept_comments
  #  end
    true
  end

end
