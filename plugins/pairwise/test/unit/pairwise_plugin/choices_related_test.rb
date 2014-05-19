require "test_helper"
require "#{Rails.root}/plugins/pairwise/test/fixtures/pairwise_content_fixtures"

class PairwisePlugin::ChoicesRelatedTest < ActiveSupport::TestCase

  def setup
    @pairwise_content = PairwiseContentFixtures.pairwise_content
  end

  should 'have choice id' do
    choices_related = PairwisePlugin::ChoicesRelated.new
    choices_related.valid?
    assert choices_related.errors.include?(:choice_id)

    choices_related.choice_id = 1
    choices_related.valid?
    assert !choices_related.errors.include?(:choice_id)
  end

  should 'have parent choice id' do
    choices_related = PairwisePlugin::ChoicesRelated.new
    choices_related.valid?
    assert choices_related.errors.include?(:parent_choice_id)

    choices_related.parent_choice_id = 1
    choices_related.valid?
    assert !choices_related.errors.include?(:parent_choice_id)
  end

  should 'belongs to a question' do
    choices_related = PairwisePlugin::ChoicesRelated.new
    choices_related.valid?
    assert choices_related.errors.include?(:question)

    choices_related.question = @pairwise_content
    choices_related.valid?
    assert !choices_related.errors.include?(:question)
  end

  should 'optionally have an user' do
     @user = create_user('testinguser')
     choices_related = PairwisePlugin::ChoicesRelated.new
     assert choices_related.user_id.nil?
     choices_related.user = @user
     assert_equal @user.id, choices_related.user_id
  end

  should 'search for related choices' do
    PairwisePlugin::ChoicesRelated.create!(:question => @pairwise_content, :choice_id => 1, :parent_choice_id =>2)
    assert_equal 1, PairwisePlugin::ChoicesRelated.related_choices_for(1).size
    assert_equal 1, PairwisePlugin::ChoicesRelated.related_choices_for(2).size
  end
end
