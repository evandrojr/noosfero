class ArticleFollower < ActiveRecord::Base
  attr_accessible :article_id, :person_id, :since
  belongs_to :article, :counter_cache => :followers_count
  belongs_to :person
end
