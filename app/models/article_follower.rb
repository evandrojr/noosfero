class ArticleFollower < ActiveRecord::Base
  attr_accessible :article_id, :person_id, :since
  belongs_to :article
  belongs_to :person
end
