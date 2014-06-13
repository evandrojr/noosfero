class PairwisePlugin::QuestionsGroupListBlock < Block

  def self.description
    _('Display question of a group of questions')
  end

  def help
    _('This block displays one of your pairwise questions in a predefined group. You can edit the block to select which one of your questions is going to be displayed in the block.')
  end

  settings_items :group_description, :type => String

  attr_accessible :group_description, :questions_ids, :random_sort

  def content(args={})
    block = self
    questions = questions.shuffle if(questions)
    #proc do
    #  content = block_title(block.title)
    #  content += ( question ? article_to_html(question,:gallery_view => false, :format => 'full').html_safe : _('No Question selected yet.') )
    #end
    proc do
      render :file => 'blocks/questions_group_list', :locals => {:block => block}
    end
  end

  def random_sort= value
    self.settings[:random_sort] = value
  end

  def random_sort
    self.settings[:random_sort]
  end

  def is_random?
    random_sort && !'0'.eql?(random_sort)
  end

  def contains_question?(id)
    if self.settings[:questions_ids]
      self.settings[:questions_ids].include?(id.to_s) 
    else 
      return false
    end
  end

   def questions_ids
    self.settings[:questions_ids]
  end

  def questions_ids= value
    if value.is_a?(Array)
      self.settings[:questions_ids] =  value
    else
      self.settings[:questions_ids] = value.nil? ? [] : value.split(",")
    end
    self.settings[:questions_ids].delete('')
  end

  def questions_for_view
    result = nil
    if questions && questions.length > 0
       result = is_random? ? questions.shuffle : questions
    end
    result
  end

  def questions(reload = false)
    @questions = nil if reload
    if @questions || questions_ids
      begin
        @questions = []
        questions_ids.each do |id|
          @questions << Article.find(id)
        end
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
    result = []
    conditions = {}
    if questions_ids && !questions_ids.empty?
      questions_ids.each do |id|
        if self.owner.kind_of?(Environment) 
          question = self.owner.portal_community.questions.find(id) 
        else
          question = self.owner.questions.find(id)
        end          
        result << question
      end     
      conditions = { :conditions => ['id not in (?)', questions_ids] }
    end

    if self.owner.kind_of?(Environment) 
      result += self.owner.portal_community.questions.find(:all, conditions)
    else 
      result += self.owner.questions.find(:all, conditions)
    end
    result
  end

  def self.expire_on
      { :profile => [:article], :environment => [:article] }
  end

  def timeout
    1.hours
  end

  def embedable?
    true
  end
end
