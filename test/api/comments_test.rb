require_relative 'test_helper'

class CommentsTest < ActiveSupport::TestCase

  should 'logged user not list comments if user has no permission to view the source article' do
    login_api
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing", :published => false)
    assert !article.published?

    get "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    assert_equal 403, last_response.status
  end

  should 'logged user not return comment if user has no permission to view the source article' do
    login_api
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing", :published => false)
    comment = article.comments.create!(:body => "another comment", :author => user.person)
    assert !article.published?

    get "/api/v1/articles/#{article.id}/comments/#{comment.id}?#{params.to_query}"
    assert_equal 403, last_response.status
  end

  should 'logged user not comment an article if user has no permission to view it' do
    login_api
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing", :published => false)
    assert !article.published?

    post "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    assert_equal 403, last_response.status
  end

  should 'logged user return comments of an article' do
    login_api
    article = fast_create(Article, :profile_id => user.person.id, :name => "Some thing")
    article.comments.create!(:body => "some comment", :author => user.person)
    article.comments.create!(:body => "another comment", :author => user.person)

    get "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 200, last_response.status
    assert_equal 2, json["comments"].length
  end

  should 'logged user return comment of an article' do
    login_api
    article = fast_create(Article, :profile_id => user.person.id, :name => "Some thing")
    comment = article.comments.create!(:body => "another comment", :author => user.person)

    get "/api/v1/articles/#{article.id}/comments/#{comment.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 200, last_response.status
    assert_equal comment.id, json['comment']['id']
  end

  should 'logged user comment an article' do
    login_api
    article = fast_create(Article, :profile_id => user.person.id, :name => "Some thing")
    body = 'My comment'
    params.merge!({:body => body})

    post "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 201, last_response.status
    assert_equal body, json['comment']['body']
  end

  should 'logged user comment creation define the source' do
      login_api
      amount = Comment.count
      article = fast_create(Article, :profile_id => user.person.id, :name => "Some thing")
      body = 'My comment'
      params.merge!({:body => body})

      post "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
      assert_equal amount + 1, Comment.count
      comment = Comment.last
      assert_not_nil comment.source
  end

  should 'not anonymous list comments if has no permission to view the source article' do
    anonymous_setup
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing", :published => false)
    assert !article.published?

    get "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    assert_equal 403, last_response.status
  end

  should 'anonymous return comments of an article' do
    anonymous_setup
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing")
    article.comments.create!(:body => "some comment", :author => person)
    article.comments.create!(:body => "another comment", :author => person)

    get "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 200, last_response.status
    assert_equal 2, json["comments"].length
  end

  should 'anonymous return comment of an article' do
    anonymous_setup
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing")
    comment = article.comments.create!(:body => "another comment", :author => person)

    get "/api/v1/articles/#{article.id}/comments/#{comment.id}?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 200, last_response.status
    assert_equal comment.id, json['comment']['id']
  end

  should 'not anonymous comment an article (at least so far...)' do
    anonymous_setup
    person = fast_create(Person)
    article = fast_create(Article, :profile_id => person.id, :name => "Some thing")
    body = 'My comment'
    name = "John Doe"
    email = "JohnDoe@gmail.com"
    params.merge!({:body => body, name: name, email: email})
    post "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 401, last_response.status
  end

  should 'paginate comments' do
    article = fast_create(Article, :profile_id => user.person.id, :name => "Some thing")
    5.times { article.comments.create!(:body => "some comment", :author => user.person) }
    params[:per_page] = 3

    get "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 200, last_response.status
    assert_equal 3, json["comments"].length
  end

  should 'return only root comments' do
    article = fast_create(Article, :profile_id => user.person.id, :name => "Some thing")
    comment1 = article.comments.create!(:body => "some comment", :author => user.person)
    comment2 = article.comments.create!(:body => "another comment", :author => user.person, :reply_of_id => comment1.id)
    params[:without_reply] = true

    get "/api/v1/articles/#{article.id}/comments?#{params.to_query}"
    json = JSON.parse(last_response.body)
    assert_equal 200, last_response.status
    assert_equal [comment1.id], json["comments"].map { |c| c['id'] }
  end
end
