require File.dirname(__FILE__) + '/test_helper'

class SearchTest < ActiveSupport::TestCase

  def create_article_with_optional_category(name, profile, category = nil)
    fast_create(Article, {:name => name, :profile_id => profile.id }, :search => true, :category => category)
  end

  should 'not list unpublished articles' do
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing", :published => false)
    assert !article.published?  	
    get "/api/v1/search/article"
    json = JSON.parse(last_response.body)    
    assert_empty json['results']
  end

  should 'list articles' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
    get "/api/v1/search/article"
    json = JSON.parse(last_response.body)
    assert_not_empty json['results']
  end

  should 'invalid search string articles' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
    get "/api/v1/search/article?query=test"
    json = JSON.parse(last_response.body)    
    assert_empty json['results']
  end

  should 'do not list articles of wrong type' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
    get "/api/v1/search/article?type=TinyMceArticle"
    json = JSON.parse(last_response.body)
    assert_empty json['results']
  end

  should 'list articles of one type' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
  	article = fast_create(TinyMceArticle, :profile_id => person.id, :name => "Some thing", :published => true)
    get "/api/v1/search/article?type=TinyMceArticle"
    json = JSON.parse(last_response.body)
    assert_equal 1, json['results'].size
  end

  should 'list articles of one type and query string' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
  	art1 = create_article_with_optional_category('article for query', person)
  	article = fast_create(TinyMceArticle, :profile_id => person.id, :name => "Some thing", :published => true)
    get "/api/v1/search/article?type=TinyMceArticle&query=thing"
    json = JSON.parse(last_response.body)
    assert_equal 1, json['results'].size
  end
end