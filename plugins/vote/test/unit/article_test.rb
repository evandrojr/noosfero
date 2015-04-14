require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  def setup
    @profile = create_user('testing').person
  end

  attr_reader :profile

  should 'vote in a article' do
    article = create(Article, :name => 'Test', :profile => profile, :last_changed_by => nil)
    profile.vote(article, 5)
    assert_equal 1, article.voters_who_voted.length
    assert_equal 5, article.votes_total
  end

  should 'be able to remove a voted article' do
    article = create(Article, :name => 'Test', :profile => profile, :last_changed_by => nil)
    profile.vote(article, 5)
    article.destroy
  end

  should 'be able to vote in an article without a user' do
    article = create(Article, :name => 'Test', :profile => profile, :last_changed_by => nil)
    assert_difference 'article.votes_for', 2 do
      Vote.create!(:voteable => article, :vote => 1)
      Vote.create!(:voteable => article, :vote => 1)
    end
  end

end
