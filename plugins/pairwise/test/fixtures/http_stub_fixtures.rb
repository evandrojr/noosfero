require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "#{Rails.root}/plugins/pairwise/test/fixtures/vcr_cassettes"
  c.hook_into :webmock
end

class HttpStubFixtures
  attr_accessor :client

  def initialize(pairwise_env_settings)
    @client = Pairwise::Client.build('1', pairwise_env_settings)
  end

  def create_question(id_question, name, choices)
    VCR.use_cassette('pairwise_create_question_dynamic', 
                        :erb => { :id_question => id_question, :question_name => name, :choices => choices }
                    ) do
      @client.create_question(name, choices)
    end
  end
end
