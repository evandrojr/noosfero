require_dependency 'profile'

Profile.class_eval do
  has_many :questions, :source => 'articles', :class_name => 'PairwisePlugin::PairwiseContent', :order => 'start_date'
end