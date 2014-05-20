class PairwisePlugin::PairwiseQuestionBlock < Block

  settings_items :pairwise_question_id, :type => :integer

  alias :profile :owner

  def self.description
    _('Display active pairwise question')
  end

  def help
    _('This block displays a pairwise question.')
  end

  def content(args={})
    block = self
    proc do
      pairwise_client = new PairwiseClient(owner.id)
      question = pairwise_client.get_question(pairwise_question_id)
      if !question.blank?
        block_title(question.name) + content_tag('div',
            render(:file => 'blocks/pairwise_question', :locals => {:question => question}), :class => 'contents', :id => "pairwise_question_#{block.id}")
      else
        ''
      end
    end
  end

  def cacheable?
    false
  end
end
