class PairwisePlugin::QuestionsGroupBlock < Block

  def self.description
    _('Display question of a group of questions')
  end

  def help
    _('This block displays one of your pairwise questions in a predefined group. You can edit the block to select which one of your questions is going to be displayed in the block.')
  end


  def content(args={})
    block = self
    question = pick_question
    proc do
      content = block_title(block.title)
      content += ( question ? article_to_html(question,:gallery_view => false, :format => 'full').html_safe : _('No Question selected yet.') )
    end
  end

   def questions_ids
    self.settings[:questions_ids]
  end

  def questions_ids= value
    if value.is_a?(Array)
      self.settings[:questions_ids] =  value
    else
      self.settings[:questions_ids] = value.nil? ? [] : [value]
    end
    self.settings[:questions_ids].delete('')
  end

  def pick_question
    (questions && questions.length > 0) ? questions[Kernel.rand(questions.size)] : nil
  end

  def questions(reload = false)
    @questions = nil if reload
    if @questions || questions_ids
      begin
        @questions = Article.find(:all, :conditions => {'id' => questions_ids})
      rescue ActiveRecord::RecordNotFound
        # dangling reference, clear it
        @questions = []
        self.questions_ids = nil
        self.save!
      end
    end
    @questions
  end

  def questions=(arr)
    self.questions_ids = arr.select {|x| x.attribute[:id] }
    @questions = arr
  end

  def available_questions
    return [] if self.owner.nil?
    self.owner.kind_of?(Environment) ? self.owner.portal_community.questions : self.owner.questions
  end

  def self.expire_on
      { :profile => [:article], :environment => [:article] }
  end

  def cacheable?
    false
  end
end
