require_relative "../test_helper"

class EmailTemplateTest < ActiveSupport::TestCase

  should 'filter templates by type' do
    EmailTemplate.create!(:template_type => :type1, :name => 'template1')
    EmailTemplate.create!(:template_type => :type2, :name => 'template2')
    EmailTemplate.create!(:template_type => :type2, :name => 'template3')
    assert_equal ['template2', 'template3'], EmailTemplate.find_all_by_template_type(:type2).map(&:name)
  end

  should 'parse body using params' do
    template = EmailTemplate.new(:body => 'Hi {{person}}')
    assert_equal 'Hi John', template.parsed_body({:person => 'John'})
  end

  should 'parse subject using params' do
    template = EmailTemplate.new(:subject => 'Hi {{person}}')
    assert_equal 'Hi John', template.parsed_subject({:person => 'John'})
  end

  should 'not create template with the same name of other' do
    template1 = EmailTemplate.new(:template_type => :type1, :name => 'template')
    template2 = EmailTemplate.new(:template_type => :type1, :name => 'template')
    assert template1.save
    assert !template2.save
  end

  should 'not create duplicated template when template type is unique' do
    template1 = EmailTemplate.new(:template_type => :user_activation, :name => 'template1')
    template2 = EmailTemplate.new(:template_type => :user_activation, :name => 'template2')
    assert template1.save
    assert !template2.save
  end

  should 'create duplicated template when template type is not unique' do
    template1 = EmailTemplate.new(:template_type => :task_rejection, :name => 'template1')
    template2 = EmailTemplate.new(:template_type => :task_rejection, :name => 'template2')
    assert template1.save
    assert template2.save
  end

end
