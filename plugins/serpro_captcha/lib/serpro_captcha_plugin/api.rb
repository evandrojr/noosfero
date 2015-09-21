class SerproCaptchaPlugin::API < Grape::API

  resource :dialoga_plugin do
      get 'random_topics/:discussion_id' do
          discussion = ProposalsDiscussionPlugin::Discussion.find(params[:discussion_id])

          # render articles using Entity Article
          present discussion.random_topics_one_by_category, :with => Noosfero::API::Entities::Article, :fields => params[:fields]
      end
  end

end
