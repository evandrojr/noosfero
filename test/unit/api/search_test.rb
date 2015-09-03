require File.dirname(__FILE__) + '/test_helper'

class SearchTest < ActiveSupport::TestCase

  def create_article_with_optional_category(name, profile, category = nil)
    fast_create(Article, {:name => name, :profile_id => profile.id }, :search => true, :category => category, :title => name)
  end

  should 'not list unpublished articles' do
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing", :published => false)
    assert !article.published?  	
    get "/api/v1/search/article"
    json = JSON.parse(last_response.body)    
    assert_empty json['articles']
  end

  should 'list articles' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
    get "/api/v1/search/article"
    json = JSON.parse(last_response.body)
    assert_not_empty json['articles']
  end

  should 'invalid search string articles' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
    get "/api/v1/search/article?query=test"
    json = JSON.parse(last_response.body)    
    assert_empty json['articles']
  end

  should 'do not list articles of wrong type' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
    get "/api/v1/search/article?type=TinyMceArticle"
    json = JSON.parse(last_response.body)
    assert_empty json['articles']
  end

  should 'list articles of one type' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
  	article = fast_create(TinyMceArticle, :profile_id => person.id, :name => "Some thing", :published => true)
    get "/api/v1/search/article?type=TinyMceArticle"
    json = JSON.parse(last_response.body)
    assert_equal 1, json['articles'].count
  end

  should 'list articles of one type and query string' do
  	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
  	art1 = create_article_with_optional_category('article for query', person)
  	article = fast_create(TinyMceArticle, :profile_id => person.id, :name => "Some thing", :published => true)
    get "/api/v1/search/article?type=TinyMceArticle&query=thing"
    json = JSON.parse(last_response.body)
    assert_equal 1, json['articles'].count
  end

  should 'not return more entries than page limit' do
  	person = fast_create(Person)
    ('1'..'5').each do |n|
      art = create_article_with_optional_category("Article #{n}", person)
    end

    get "/api/v1/search/article?query=Article&per_page=3"
    json = JSON.parse(last_response.body)

    assert_equal 3, json['articles'].count
  end

  should 'return entries second page' do
  	person = fast_create(Person)
    ('1'..'5').each do |n|
      art = create_article_with_optional_category("Article #{n}", person)
    end

    get "/api/v1/search/article?query=Article&per_page=3&page=2"
    json = JSON.parse(last_response.body)

    assert_equal 2, json['articles'].count
  end

  should 'search articles in profile' do
  	person1 = fast_create(Person)
  	person2 = fast_create(Person)

  	art1 = create_article_with_optional_category("Article 1 for profile #{person1.id}", person1)
  	art2 = create_article_with_optional_category("Article for profile #{person2.id}", person2)
  	art3 = create_article_with_optional_category("Article 2 for profile #{person1.id}", person1)

    get "/api/v1/search/article?query=Article&profile_id=#{person1.id}"
    json = JSON.parse(last_response.body)
    # Only for person1
    assert_equal 2, json['articles'].count
  end

  should 'search with fields' do
	person = fast_create(Person)
  	art = create_article_with_optional_category('an article to be found', person)
    get "/api/v1/search/article?fields=title"
    json = JSON.parse(last_response.body)
    assert_not_empty json['articles']
	assert_equal ['title'], json['articles'].first.keys
  end
end