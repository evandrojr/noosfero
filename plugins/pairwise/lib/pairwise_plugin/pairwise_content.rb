class PairwisePlugin::PairwiseContent < Article
  include ActionView::Helpers::TagHelper
  settings_items :pairwise_question_id
  settings_items :allow_new_ideas, :type => :boolean, :default => true

  before_save :send_question_to_service

  validate_on_create :validate_choices

  REASONS_ARRAY = [
     {:text => _("I like both ideas"), :compare => false},
     {:text => _("I think both ideas are the same"), :compare => false},
     {:text => _("I don't know enough about either idea"),:compare => false},
     {:text => _("I don't like either idea"), :compare => false},
     {:text => _("I don't know enough about: "),:compare => true},
     {:text => _("I just can't decide"),:compare => false}
  ]

  def initialize(*args)
    super(*args)
    self.published = false
    self.accept_comments = false
    self.notify_comments = false
    @next_prompt = nil
  end

  def has_next_prompt?
    @next_prompt.present?
  end

  alias_method :original_view_url, :view_url

  def result_url
    profile.url.merge(
                      :controller => :pairwise_plugin_profile,
                     :action => :result,
                      :id => id)
  end

  def prompt_url
    profile.url.merge(
                      :controller => :pairwise_plugin_profile,
                      :action => :prompt_tab,
                      :id => id)
  end

  def self.short_description
    'Pairwise question'
  end

  def self.description
    'Question managed by pairwise'
  end

  def to_html(options = {})
    source = options["source"]
    embeded = options.has_key? "embeded"
    prompt_id = options["prompt_id"]
    pairwise_content = self
    lambda do
      locals = {:pairwise_content =>  pairwise_content, :source => source, :embeded => embeded, :prompt_id => prompt_id }
      render :file => 'content_viewer/prompt.rhtml', :locals => locals
    end
  end

  def pairwise_client
    @pairwise_client ||= Pairwise::Client.build(profile.id, environment.settings[:pairwise_plugin])
    @pairwise_client
  end


  def prepare_prompt(user_identifier, prompt_id=nil)
    prepared_question = question
    if has_next_prompt?
      prepared_question.set_prompt @next_prompt
    else
      prepared_question = self.question_with_prompt_for_visitor(user_identifier, prompt_id)
    end
    prepared_question
  end

  def question
    begin
      @question ||= pairwise_client.find_question_by_id(pairwise_question_id)
    rescue Exception => error
      errors.add_to_base(error.message)
    end
    @question
  end

  def question_with_prompt_for_visitor(visitor='guest', prompt_id=nil)
    pairwise_client.question_with_prompt(pairwise_question_id, visitor, prompt_id)
  end

  def description=(value)
    @description=value
  end

  def description
    begin
      @description ||= question.name
    rescue
      @description = ""
    end
    @description
  end

  def pending_choices(filter, order)
    if(question)
      @inactive_choices ||= question.pending_choices(filter, order)
    else
      []
    end
  end

  def reproved_choices(filter, order)
    @reproved_choices ||= question ? question.reproved_choices(filter, order) : []
  end

  def inactive_choices(options={})
    if(question)
      @inactive_choices ||= (question.choices_include_inactive - question.get_choices)
    else
      []
    end
  end

  def raw_choices(filter=nil, order=nil)
    return [] if pairwise_question_id.nil?
    @raw_choices ||= question ? question.get_choices(filter, order) : []
  end

  def choices
    if raw_choices.nil?
      @choices = []
    else
      begin
        @choices ||= question.get_choices.map {|q| { q.id.to_s, q.data } }
      rescue
       @choices = []
      end
    end
    @choices
  end

  def choices=(value)
    @choices = value
  end

  def choices_saved
    @choices_saved
  end

  def choices_saved=value
    @choices_saved = value
  end

  def vote_to(prompt_id, direction, visitor, appearance_id)
    raise _("Excepted question not found") if question.nil?
    next_prompt = pairwise_client.vote(question.id, prompt_id, direction, visitor, appearance_id)
    touch #invalidates cache
    set_next_prompt(next_prompt)
    next_prompt
  end

  def skip_prompt(prompt_id, visitor, appearance_id, reason=nil)
    next_prompt = pairwise_client.skip_prompt(question.id, prompt_id, visitor, appearance_id, reason)
    touch #invalidates cache
    set_next_prompt(next_prompt)
    next_prompt
  end

  def ask_skip_reasons(prompt)
    reasons = REASONS_ARRAY.map do |item|
      if item[:compare]
        [ item[:text] + prompt.left_choice_text,  item[:text] + prompt.right_choice_text]
      else
        item[:text]
      end
    end
    reasons.flatten
  end

   def validate_choices
    errors.add_to_base(_("Choices empty")) if choices.nil?
    errors.add_to_base(_("Choices invalid format")) unless choices.is_a?(Array)
    errors.add_to_base(_("Choices invalid")) if choices.size == 0
    choices.each do | choice |
      if choice.empty?
        errors.add_to_base(_("Choice empty"))
        break
      end
    end
  end

  def update_choice(choice_id, choice_text, active)
    begin
      return pairwise_client.update_choice(question, choice_id, choice_text, active)
    rescue Exception => e
      errors.add_to_base(N_("Choices:") + " " + N_(e.message))
      return false
    end
  end

  def approve_choice(choice_id)
    begin
      return pairwise_client.approve_choice(question, choice_id)
    rescue Exception => e
      errors.add_to_base(N_("Choices:") + " " + N_(e.message))
      return false
    end
  end

  def flag_choice(choice_id, explanation=nil)
    pairwise_client.flag_choice(question, choice_id, explanation || 'reproved')
  end

  def find_choice id
    return nil if question.nil?
    question.find_choice id
  end

  def toggle_autoactivate_ideas(active_flag)
    pairwise_client.toggle_autoactivate_ideas(question, active_flag)
  end

  def send_question_to_service
    if new_record?
      @question = create_pairwise_question
      self.pairwise_question_id = @question.id
      toggle_autoactivate_ideas(false)
    else
      #add new choices
      unless @choices.nil?
        @choices.each do |choice_text|
          begin
            unless choice_text.empty?
              choice = pairwise_client.add_choice(pairwise_question_id, choice_text)
              pairwise_client.approve_choice(question, choice.id)
            end
          rescue Exception => e
            errors.add_to_base(N_("Choices: Error adding new choice to question") + N_(e.message))
            return false
          end
        end
      end
      #change old choices
      unless @choices_saved.nil?
        @choices_saved.each do |id,data|
          begin
            pairwise_client.update_choice(question, id, data, true)
          rescue Exception => e
            errors.add_to_base(N_("Choices:") + " " + N_(e.message))
            return false
          end
        end
      end
      begin
        pairwise_client.update_question(pairwise_question_id, name)
      rescue Exception => e
        errors.add_to_base(N_("Question not saved:  ") + N_(e.message))
        return false
      end
    end
  end

  def create_pairwise_question
    question = pairwise_client.create_question(name, choices)
    question
  end

  def ideas_contributors(options=nil)
    question.get_ideas_contributors(options)
  end

  def allow_new_ideas?
    allow_new_ideas
  end

  def add_new_idea(text, visitor=nil)
    return false unless allow_new_ideas?
    pairwise_client.add_new_idea(pairwise_question_id, text, visitor)
  end

  def join_choices(ids_choices_to_join, id_choice_elected, user)
     ids_choices_to_join.each do |id_choice|
       unless id_choice.eql?(id_choice_elected)
          choice = question.find_choice(id_choice)
          choice_related = PairwisePlugin::ChoicesRelated.new do |cr|
            cr.question = self
            cr.choice_id = choice.id
            cr.parent_choice_id = id_choice_elected
            cr.user = user
            cr.save!
           end
       end
    end
   end

  def copy(options = {})
    attrs = attributes.reject! { |key, value| ATTRIBUTES_NOT_COPIED.include?(key.to_sym) }
    attrs.merge!(options)
    obj = self.class.new(attrs)
    obj.pairwise_question_id = self.pairwise_question_id
    obj.allow_new_ideas = self.allow_new_ideas
    id = obj.send(:create_without_callbacks)
    raise "Objeto não gravado" unless id
  end

  def copy!(options = {})
    attrs = attributes.reject! { |key, value| ATTRIBUTES_NOT_COPIED.include?(key.to_sym) }
    attrs.merge!(options)
    #self.class.create!(attrs)
    obj = self.class.new(attrs)
    obj.pairwise_question_id = self.pairwise_question_id
    obj.allow_new_ideas = self.allow_new_ideas
    id = obj.send(:create_without_callbacks)
    raise "Objeto não gravado" unless id
  end

  def page_size
    20
  end

private

  def set_next_prompt(prompt)
    @next_prompt = Pairwise::Prompt.new(prompt["prompt"])
  end
end
