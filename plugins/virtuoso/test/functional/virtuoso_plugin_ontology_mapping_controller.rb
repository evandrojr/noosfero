require 'test_helper'

class VirtuosoPluginOntologyMappingControllerTest < ActionController::TestCase

  setup do
    @environment = Environment.default
    @plugin = VirtuosoPlugin.new(self)
    login_as(create_admin_user(environment))
    @ontology_mapping = [{'source' => 'title',   'target' => 'http://purl.org/dc/elements/1.1/title'},
                         {'source' => 'creator', 'target' => 'http://purl.org/dc/elements/1.1/creator'}]
  end

  attr_reader :environment, :plugin, :ontology_mapping

  should 'list saved mappings' do
    settings = plugin.settings
    settings.ontology_mapping = ontology_mapping
    settings.save!
    get :index
    assert_select "#ontology-table tr", 3 do
      assert_select "input[name='ontology_mapping[][source]']"
      assert_select "input[name='ontology_mapping[][target]']"
    end
  end

  should 'save ontology mappings' do
    post :index, 'ontology_mapping' => ontology_mapping
    @environment = environment.reload
    assert_equivalent ontology_mapping, plugin.settings.ontology_mapping
  end

end
