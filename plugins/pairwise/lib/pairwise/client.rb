class Pairwise::Client

  private_class_method :new

  ###
  # constructor for a pairwise client
  # local_identifier is the id of the question owner in the client app side
  def initialize(local_identifier)
    @local_identifier = local_identifier
  end

  # creates a new question in pairwise
  def create_question(name, ideas = [])
    ideas = ideas.join("\n") if ideas.is_a? Array
    q = Pairwise::Question.create({
                      :name => name,
                      :visitor_identifier => @local_identifier.to_s,
                      :local_identifier => @local_identifier.to_s,
                      :ideas => ideas
                    })
    q.it_should_autoactivate_ideas = true
    q.active = true
    q.save
    q
  end

  def toggle_autoactivate_ideas(question, value)
    question.it_should_autoactivate_ideas = value
    question.save
  end

  def add_choice(question_id, choice_text, visitor=nil)
    question = Pairwise::Question.find question_id
    raise Pairwise::Error.new("Question not found in pairwise") if question.nil?
    visitor_identifier = visitor.blank? ? @local_identifier.to_s : visitor
    choice_args = {
                    :question_id => question_id,
                    :local_identifier => @local_identifier.to_s,
                    :visitor_identifier => visitor_identifier,
                    :data => choice_text
                  }
    Pairwise::Choice.create(choice_args)
  end

  def update_question(question_id, name)
    question = Pairwise::Question.find question_id
    question.name = name
    question.save
  end

  def update_choice(question, choice_id, choice_data, active)
    choice = Pairwise::Choice.find(choice_id, :params => {:question_id => question.id })
    raise N_("Invalid choice id") unless choice
    raise Pairwise::Error.new N_("Empty choice text") if choice_data.empty?
    unless choice_data.eql?(choice.data) && choice.active.eql?(active)
      choice.data = choice_data
      choice.active = active
      choice.save
    end
  end

  def approve_choice(question, choice_id)
    choice = Pairwise::Choice.find(choice_id, :params => {:question_id => question.id})
    raise N_("Invalid choice id") unless choice
    choice.active = true
    choice.save
  end

  def flag_choice(question, choice_id, reason)
    choice = Pairwise::Choice.find(choice_id, :params => {:question_id => question.id})
    raise N_("Invalid choice id") unless choice
        
    choice.put(:flag,
                    :visitor_identifier => @local_identifier.to_s,
                    :explanation => reason)
  end

  # finds a question by a given id
  def find_question_by_id(question_id)
    question = Pairwise::Question.find question_id
    return question #if question.local_identifier == @local_identifier.to_s
  end

  # returns all questions in pairwise owned by the local_identifier user
  def questions
    questions = Pairwise::Question.find(:all, :params => {:creator => @local_identifier})
    questions.select {|q| q if q.local_identifier == @local_identifier.to_s }
  end

  # get a question with a prompt, visitor_id (id of logged user) should be provided
  def question_with_prompt(question_id, visitor_id = "guest", prompt_id=nil)
    question = Pairwise::Question.find_with_prompt(question_id, @local_identifier, visitor_id)
    return question #if question.local_identifier == @local_identifier.to_s
  end

  # register votes in response to a prompt to a pairwise question
  def vote(question_id, prompt_id, direction, visitor="guest", appearance_lookup=nil)
    prompt = Pairwise::Prompt.find(prompt_id, :params => {:question_id => question_id})
    begin
      vote = prompt.post(:vote,
                         :question_id => question_id,
                         :vote => {
                           :direction => direction,
                           :visitor_identifier => visitor,
                           :appearance_lookup => appearance_lookup
                         },
                         :next_prompt => {
                           :with_appearance => true,
                           :with_visitor_stats => true,
                           :visitor_identifier => visitor
                         })
      Hash.from_xml(vote.body)
    rescue ActiveResource::ResourceInvalid => e
      raise Pairwise::Error.new(_("Vote not registered. Please check if all the necessary parameters were passed."))
    end
  end

  def skip_prompt(question_id, prompt_id, visitor="guest", appearance_lookup=nil, reason=nil)
    prompt = Pairwise::Prompt.find(prompt_id, :params => {:question_id => question_id})
    begin
      skip = prompt.post(:skip, :question_id => question_id,
         :skip => {
            :appearance_lookup => appearance_lookup,
            :visitor_identifier => visitor, 
            :skip_reason => (reason.nil? ? 'some not informed reason' : reason)
          },
           :next_prompt => {
             :with_appearance => true,
             :with_visitor_stats => true,
             :visitor_identifier => visitor
          }
        )
      Hash.from_xml(skip.body)
    rescue ActiveResource::ResourceInvalid => e
      raise Pairwise::Error.new(_("Could not skip vote. Check the parameters"))
    end
  end

  # skips a prompt
  def skip(prompt_id, question_id, visitor_id = "guest", appearance_lookup = nil)
     prompt = Pairwise::Prompt.find(prompt_id, :params => {:question_id => question_id})
     skip = prompt.post(:skip,
                       :question_id => question_id,
                       :skip => {
                         :visitor_identifier => visitor_id,
                         :appearance_lookup => appearance_lookup
                       },
                       :next_prompt => {
                         :with_appearance => true,
                         :with_visitor_stats => true,
                         :visitor_identifier => visitor_id
                       })

  end

  def pairwise_config
    options = environment.settings[:pairwise_plugin]
     [:api_host, :username, :password].each do |key|
        if options.keys.include?(key.to_s)
          Pairwise::ResourceSettings[key] = options[key.to_s]
        end
      end

  end

  def self.build(local_identifier, settings)
    if settings.nil?
      error_message = "#{_("Plugin was not configured")}. #{_("Please contact the administrator")}"
      raise Pairwise::Error.new error_message
    end
    [Pairwise::Question, Pairwise::Prompt, Pairwise::Choice, Pairwise::Visitor].each do | klas |
      if([Pairwise::Prompt, Pairwise::Choice].include?(klas))
        klas.site = settings[:api_host] +  "questions/:question_id/"
      else
        klas.site = settings[:api_host]
      end
      klas.user =  settings[:username]
      klas.password = settings[:password]
    end
    new local_identifier
  end

  def add_new_idea(question_id, text, visitor=nil)
    raise _("Idea text is empty") if text.empty?
    question = Pairwise::Question.find question_id
    raise Pairwise::Error.new("Question not found in pairwise") if question.nil?
    visitor_identifier = visitor.blank? ? @local_identifier.to_s : visitor
    choice_args = {
                    :question_id => question_id,
                    :local_identifier => @local_identifier.to_s,
                    :visitor_identifier => visitor_identifier,
                    :data => text
                  }
    return Pairwise::Choice.create(choice_args)
  end
end

