class PairwiseContentFixtures

  def self.pairwise_content
    content = PairwisePlugin::PairwiseContent.new
    content.pairwise_question_id = 1
    content.name = "Question 1"
    content.choices = ["choice1,choice2"]
    content
  end

  def self.content_stub_with_3_choices
    content = PairwisePlugin::PairwiseContent.new
    content.pairwise_question_id = 1
    content.name = "Question 1"
    content.choices = ["choice1,choice2,choice3"]
    content

    question = Pairwise::Question.new(:id =>1, :name => "Question 1")
    choices = []
    choices << Pairwise::Choice.new(:id => 1, :data => "Choice1")
    choices << Pairwise::Choice.new(:id => 2, :data => "Choice2")
    choices << Pairwise::Choice.new(:id => 3, :data => "Choice3")

    question.stubs(:find_choice).with(1).returns(choices[0])
    question.stubs(:find_choice).with(2).returns(choices[1])
    question.stubs(:find_choice).with(3).returns(choices[2])

     question.stubs(:choices => choices)
     content.stubs(:question => question)
     content
  end

  def self.new_pairwise_content
    PairwisePlugin::PairwiseContent.new do |content|
      content.name = "New question content"
      content.published = true
    end
  end

  def self.pairwise_content_inactive
    content = self.pairwise_content
    content.published = false
    content
  end

  def self.pairwise_question(votes_count = 0)
    question = Pairwise::Question.new({
        :id => 1,
        :name => 'Question 1',
        :active => true,
        :description => 'Some description',
        :appearance_id =>  'abcdef',
        :votes_count => votes_count
      })
  end

  def self.pairwise_prompt
    prompt = Pairwise::Prompt.new({
        :id => 1, 
        :question_id => 1, 
        :left_choice_text => 'Option 1', 
        :left_choice_id => 1,
        :right_choice_text => 'Option 2',
        :right_choice_id => 2
      })
  end

  def self.pairwise_question_with_prompt
    question = self.pairwise_question
    question.set_prompt self.pairwise_prompt
    question
  end

  def self.choices_with_stats
    choices = []
    choices << Pairwise::Choice.new(:id => 1, :data => "Choice1", :wins => 0, :losses => 0, :score => 0.0)
    choices << Pairwise::Choice.new(:id => 2, :data => "Choice2", :wins => 0, :losses => 0, :score => 0.0)
    choices << Pairwise::Choice.new(:id => 3, :data => "Choice3", :wins => 0, :losses => 0, :score => 0.0)
  end
end