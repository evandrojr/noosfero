class ArticleFollower < ActiveRecord::Base
  attr_accessible :article_id, :person_id, :since
  belongs_to :article, :counter_cache => :followers_count
  belongs_to :person

  after_create do |article_follower|
    ArticleFollower.update_cache_counter(:followers_count, article_follower.article, 1)
  end

  after_destroy do |article_follower|
    ArticleFollower.update_cache_counter(:followers_count, article_follower.article, -1)
  end
end
