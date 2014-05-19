require "test_helper"

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "#{RAILS_ROOT}/plugins/pairwise/test/fixtures/vcr_cassettes"
  c.hook_into :webmock
end

class Pairwise::ClientTest < ActiveSupport::TestCase
  def setup
    pairwise_env_settings = { :api_host => "http://localhost:3030/",
      :username => "abner.oliveira@serpro.gov.br",
      :password => "serpro"
    }
    @client = Pairwise::Client.build('1', pairwise_env_settings)
    @choices = "Choice 1\nChoice 2"

    VCR.use_cassette('pairwise_create_question') do
      @question = @client.create_question('Q1', @choices)
    end

  end

  should 'create an new question in pairwise service' do
    assert_not_nil @question.id
  end

  should 'update a question' do
    VCR.use_cassette('pairwise_update_question') do
      @question_to_be_changed = @client.create_question('Question 1', @choices)
      @client.update_question(@question_to_be_changed.id, "New name")
      assert_equal "New name", @client.find_question_by_id(@question_to_be_changed.id).name
    end
  end

  should "add new choice to a question" do
    VCR.use_cassette('pairwise_add_new_choice') do
      assert_equal 2, @question.get_choices.size
    end
  end
   should 'record that an user created the choice' do
    VCR.use_cassette('record_choice_creator') do
      assert_equal 3, @question.get_choices.size
      @client.add_choice(@question.id, 'New Choice', 'John Travolta')
      assert_equal 4, @question.choices_include_inactive.size
      created_choice = @question.choices_include_inactive[2]
      assert_equal true, created_choice.user_created 
    end
  end

  should 'update a choice text' do
    VCR.use_cassette('pairwise_update_choice_text') do
      choice = @question.get_choice_with_text("Choice 1")
      assert_not_nil choice
      @client.update_choice(@question, choice.id, 'Choice Renamed', true)
      @question_after_change  = @client.find_question_by_id(@question.id)
      assert @question_after_change.has_choice_with_text?("Choice Renamed"), "Choice not found"
      assert ! @question_after_change.has_choice_with_text?("Choice 1"), "Choice 1 should not exist"
    end
  end

  should 'not allow change choice to a blank value' do
    VCR.use_cassette('pairwise_blank_value') do
      choice = @question.get_choice_with_text("Choice 1")
      assert_not_nil choice
      exception = assert_raises Pairwise::Error do
        @client.update_choice(@question, choice.id, '', true)
      end
      assert_equal "Empty choice text", exception.message
    end
  end


  should 'retrieve question from service' do
    VCR.use_cassette('pairwise_retrieve_question') do
      @question_retrieved = @client.find_question_by_id(@question.id)
      assert_not_nil @question_retrieved
      assert_equal @question.id, @question_retrieved.id
    end
  end

  should 'retrieve question with values correct attributes values' do
    VCR.use_cassette('pairwise_retrieve_correct_values') do
      @question_retrieved = @client.find_question_by_id(@question.id)
      assert_equal "Q1", @question_retrieved.name
    end
  end

  should 'retrieve question choices' do
    VCR.use_cassette('pairwise_retrieve_question_choices') do
      @question_retrieved = @client.find_question_by_id(@question.id)
      assert_not_nil @question_retrieved.choices
      @question_retrieved.choices.each do | choice |
        assert @choices.include?(choice.data), "Choice #{choice} not found in question retrieved"
      end
    end
  end

  should 'register votes' do
    VCR.use_cassette('pairwise_register_votes') do
      @question = @client.question_with_prompt(@question.id)
      assert_not_nil @question.prompt
      vote = @client.vote(@question.id, @question.prompt.id, 'left', 'guest-tester', @question.appearance_id)
  
      assert vote.is_a?(Hash)
      assert_not_nil vote["prompt"], "Next prompt hash expected"
      assert_not_nil vote["prompt"]["id"], "Next prompt id expected"
      assert_not_nil vote["prompt"]["question_id"], "question_id expected"
      assert_not_nil vote["prompt"]["appearance_id"], "appearance_id expected"
      assert_not_nil vote["prompt"]["left_choice_text"], "left_choice_text expected"
      assert_not_nil vote["prompt"]["right_choice_text"], "right_choice_text expected"
    end
  end

  should 'not register votes when appearance_id is missing' do
    VCR.use_cassette('pairwise_not_register_votes') do 
      @question = @client.question_with_prompt(@question.id)
      assert_not_nil @question.prompt
      exception = assert_raises Pairwise::Error do
        @client.vote(@question.id, @question.prompt.id, 'left', 'guest-tester')
      end
      assert_equal "Vote not registered. Please check if all the necessary parameters were passed.", exception.message
    end
  end

  should 'approve choice' do
    VCR.use_cassette('pairwise_approve_choice') do
      @client.toggle_autoactivate_ideas(@question, false)
      choice = @client.add_choice(@question.id, 'New inactive choice')
      assert_equal 1, (@question.choices_include_inactive - @question.choices).size
      @client.approve_choice(@question, choice.id)
      assert_equal 0, (@question.choices_include_inactive - @question.choices).size
      assert_equal 3, @question.choices.size
    end
  end

  should 'update choice' do
    VCR.use_cassette('pairwise_update_choice') do
      choice = @question.get_choices.first
      new_choice_text = choice.data + " Changes"
      assert_equal true, @client.update_choice(@question, choice.id, choice.data + " Changes", true)
      assert_equal new_choice_text, @client.find_question_by_id(@question.id).find_choice(choice.id).data
    end
  end
  
  should 'return users whom suggested ideas' do
    #Rails.logger.level = :debug # at any time
    #ActiveResource::Base.logger = Logger.new(STDERR)
    VCR.use_cassette('question_contributors') do
      @client.add_choice(@question.id, 'New Choice', 'John Travolta')
      assert_equal 1, @question.get_ideas_contributors().size
    end
  end

  should 'toggle autoactivate ideas' do
    VCR.use_cassette('pairwise_toggle_autactivate_ideas', :erb => {:autoactivateidea => false}) do
      assert_equal false, @client.find_question_by_id(@question.id).it_should_autoactivate_ideas
      @client.toggle_autoactivate_ideas(@question, true)
    end
    
    VCR.use_cassette('pairwise_toggle_autactivate_ideas', :erb => {:autoactivateidea => true}) do
      assert_equal true, @client.find_question_by_id(@question.id).it_should_autoactivate_ideas
    end
  end

  should 'flag a choice as reproved' do
    VCR.use_cassette('flag_choice_as_reproved') do
      question = @client.find_question_by_id 6
      choices_waiting_approval = question.pending_choices
      assert choices_waiting_approval.count > 0, "Expected to find a inactive choice here"
      @client.flag_choice(question, choices_waiting_approval.first.id, 'reproved')
      assert_equal 0, question.pending_choices.count
    end
  end
end