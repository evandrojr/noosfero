require_relative "../test_helper"

class EmailTemplateTest < ActiveSupport::TestCase

  should 'filter templates by type' do
    EmailTemplate.create!(:template_type => :type1, :subject => 'template1')
    EmailTemplate.create!(:template_type => :type2, :subject => 'template2')
    EmailTemplate.create!(:template_type => :type2, :subject => 'template3')
    assert_equal ['template2', 'template3'], EmailTemplate.find_all_by_template_type(:type2).map(&:subject)
  end

  should 'parse body using params' do
    template = EmailTemplate.new(:body => 'Hi {{person}}')
    assert_equal 'Hi John', template.parsed_body({:person => 'John'})
  end

  should 'parse subject using params' do
    template = EmailTemplate.new(:subject => 'Hi {{person}}')
    assert_equal 'Hi John', template.parsed_subject({:person => 'John'})
  end

end
