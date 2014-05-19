class PairwisePlugin::ChoicesRelated < Noosfero::Plugin::ActiveRecord
  set_table_name "pairwise_plugin_choices_related"
  belongs_to :question, :class_name => 'PairwisePlugin::PairwiseContent'
  belongs_to :user

  validates_presence_of :question, :choice_id, :parent_choice_id

  def self.related_choices_for choice_id
     PairwisePlugin::ChoicesRelated.find_all_by_choice_id(choice_id) + PairwisePlugin::ChoicesRelated.find_all_by_parent_choice_id(choice_id)
  end

end
