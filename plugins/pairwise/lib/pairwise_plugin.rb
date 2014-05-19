class PairwisePlugin < Noosfero::Plugin

  def self.plugin_name
    "PairwisePlugin"
  end

  def self.plugin_description
    _("A plugin that add a pairwise client feature to noosfero.")
  end

  # def self.extra_blocks
  #   {
  #      PairwiseBlock => {:type => ['community', 'profile'] }
  #   }
  # end

  def self.extra_blocks
    { PairwisePlugin::QuestionsGroupListBlock => {} }
  end

  def content_types
    [PairwisePlugin::PairwiseContent]
    # if context.profile.is_a?(Community)
    # else
    #   []
    # end
  end

  def stylesheet?
    true
  end

  def js_files
    'javascripts/pairwise.js'
  end

end
