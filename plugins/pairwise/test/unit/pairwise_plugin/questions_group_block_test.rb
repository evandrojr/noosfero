require 'test_helper'
require "#{RAILS_ROOT}/plugins/pairwise/test/fixtures/pairwise_content_fixtures"

class PairwisePlugin::QuestionsGroupBlockTest < ActiveSupport::TestCase

  fixtures :environments

  def setup
    @profile = create_user('testing').person
    @profile.environment = environments(:colivre_net)

    PairwisePlugin::PairwiseContent.any_instance.stubs(:send_question_to_service).returns(true)

    @question1 = PairwisePlugin::PairwiseContent.new(:name => 'Question 1', :profile => @profile, :pairwise_question_id => 1, :body => 'Body 1')
    @question1.stubs(:valid?).returns(true)
    @question1.save

    @question2 = PairwisePlugin::PairwiseContent.new(:name => 'Question 2', :profile => @profile, :pairwise_question_id => 2, :body => 'Body 2')
    @question2.stubs(:valid?).returns(true)
    @question2.save

    @block = PairwisePlugin::QuestionsGroupBlock.create(:title => "Pairwise Question Block")
    @profile.boxes.first.blocks << @block
    @block.save!
  end

  should 'have available question' do
    assert_equal [@question1, @question2], @block.available_questions
  end

  should 'add multiple questions to block' do
    @block.questions_ids = [@question1.id, @question2.id ]
    @block.save
    @block.reload
    assert_equal 2, @block.questions.length
  end

  should 'pick a question to show' do
    @block.questions_ids = [ @question1.id, @question2.id ]
    @block.save
    @block.reload
    assert_not_nil @block.pick_question
    assert_equal true, @block.pick_question.is_a?(PairwisePlugin::PairwiseContent)
  end

end
