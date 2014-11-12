require File.dirname(__FILE__) + '/../test_helper'

class TriplesTemplateTest < ActiveSupport::TestCase

  def setup
    @article = VirtuosoPlugin::TriplesTemplate.new
  end

  attr_reader :article

  should 'evaluate template using query results' do
    article.stubs(:plugin).returns(mock)
    article.plugin.expects(:virtuoso_client).at_least_once.returns(mock)
    article.plugin.virtuoso_client.expects(:query).returns([{'var' => 'Hello '}, {'var' => 'World'}])
    article.template = "{{row.var}}"

    assert_equal 'Hello World', article.template_content
  end

  should 'display error message when failed to execute the query' do
    article.stubs(:plugin).returns(mock)
    article.plugin.expects(:virtuoso_client).at_least_once.returns(mock)
    article.plugin.virtuoso_client.expects(:query).raises(RuntimeError.new)
    article.template = "{{row.var}}"

    assert_equal "Failed to process the template", article.template_content
  end

end
