require File.dirname(__FILE__) + '/../test_helper'

class TriplesTemplateTest < ActiveSupport::TestCase

  def setup
    @article = VirtuosoPlugin::TriplesTemplate.new
  end

  attr_reader :article

  should 'evaluate template using query results' do
    article.stubs(:plugin).returns(mock)
    article.plugin.expects(:virtuoso_readonly_client).at_least_once.returns(mock)
    article.plugin.virtuoso_readonly_client.expects(:query).returns([{'var' => 'Hello '}, {'var' => 'World'}])
    article.template = "{% for row in results %}{{row.var}}{% endfor %}"

    assert_match /Hello World/, article.template_content
  end

  should 'display error message when failed to execute the query' do
    article.stubs(:plugin).returns(mock)
    article.plugin.expects(:virtuoso_readonly_client).at_least_once.returns(mock)
    article.plugin.virtuoso_readonly_client.expects(:query).raises(RuntimeError.new)
    article.template = "{% for row in results %}{{row.var}}{% endfor %}"

    assert_equal "Failed to process the template", article.template_content
  end

  should 'transform css into inline stylesheet' do
    article.stubs(:plugin).returns(mock)
    article.plugin.expects(:virtuoso_readonly_client).at_least_once.returns(mock)
    article.plugin.virtuoso_readonly_client.expects(:query).returns([{'var' => 'Hello '}, {'var' => 'World'}])
    article.template = "{% for row in results %}<p>{{row.var}}</p>{% endfor %}"
    article.stylesheet = "p {color: red}"

    content = article.template_content
    assert_match /<p style="color:red">Hello <\/p>/, content
    assert_match /<p style="color:red">World<\/p>/, content
  end

  should 'do not allow js injection' do
    article.stubs(:plugin).returns(mock)
    article.plugin.expects(:virtuoso_readonly_client).at_least_once.returns(mock)
    article.plugin.virtuoso_readonly_client.expects(:query).returns([{'var' => RDF::Literal.new('<script>alert("hello");</script>')}])
    article.template = "{% for row in results %}{{row.var}}{% endfor %}"

    assert_no_match /<script>/, article.template_content
  end

end
