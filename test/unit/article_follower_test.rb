require_relative "../test_helper"

class ArticleFollowerTest < ActiveSupport::TestCase

  should 'create follower to article' do
    p = create_user('testuser').person
    article = p.articles.build(:name => 'test article'); article.save!
    article_follower = ArticleFollower.new
    article_follower.article = article
    article_follower.person = p
    article_follower.save!
    assert_equal article, article_follower.article
  end

  should 'not allow create Article Follower without an Article asssociated' do
    person = create_user('one person').person
    article_follower = ArticleFollower.new
    article_follower.person = person
    
  	assert_raises (ActiveRecord::StatementInvalid) { article_follower.save! }
  end

  should 'not allow create duplicate Article Follower' do
    person = create_user('one person').person
    article = person.articles.build(:name => 'test article'); article.save!
    article_follower = ArticleFollower.new
    article_follower.article = article
    article_follower.person = person
    article_follower.save!

    article_follower = ArticleFollower.new
    article_follower.article = article
    article_follower.person = person

  	assert_raises (ActiveRecord::RecordNotUnique) { article_follower.save! }
  end

  should 'create many followers to article' do
    p1 = create_user('testuser1').person
    p2 = create_user('testuser2').person
    p3 = create_user('testuser2').person

    article = p1.articles.build(:name => 'test article'); article.save!
    
    article_follower = ArticleFollower.new
    article_follower.article = article
    article_follower.person = p2
    article_follower.save!

    article_follower = ArticleFollower.new
    article_follower.article = article
    article_follower.person = p3
    article_follower.save!

    assert_equal article.person_followers.size, 2
  end

  should 'allow to follow many articles' do
    p1 = create_user('testuser1').person
    p2 = create_user('testuser2').person

    article1 = p2.articles.build(:name => 'test article 1'); article1.save!
    article2 = p2.articles.build(:name => 'test article 2'); article2.save!

    article_follower = ArticleFollower.new
    article_follower.article = article1
    article_follower.person = p1
    article_follower.save!

    article_follower = ArticleFollower.new
    article_follower.article = article2
    article_follower.person = p1
    article_follower.save!

    assert_equal p1.following_articiles.size, 2
  end


end
