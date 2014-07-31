require File.dirname(__FILE__) + '/../test_helper'
require 'benchmark'

class ArticleTest < ActiveSupport::TestCase

  def setup
    profile = fast_create(Community)
    @article = fast_create(Article, :profile_id => profile.id)
  end

  attr_reader :article

  should 'return paragraph comments from article' do
    comment1 = fast_create(Comment, :paragraph_id => 1, :source_id => article.id)
    comment2 = fast_create(Comment, :paragraph_id => nil, :source_id => article.id)
    assert_equal [comment1], article.paragraph_comments
  end

  should 'allow save if comment paragraph macro is not removed for paragraph with comments' do
    article.body = "<div class=\"macro\" data-macro-paragraph_id=0></div>"
    comment1 = fast_create(Comment, :paragraph_id => 0, :source_id => article.id)
    assert article.save
  end


end
