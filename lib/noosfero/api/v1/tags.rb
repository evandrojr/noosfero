module Noosfero
  module API
    module V1
      class Tags < Grape::API
        before { authenticate! }
  
        resource :articles do

          resource ':id/tags' do
  
            get do
              article = find_article(environment.articles, params[:id])
              present article.tag_list, :with => Entities::Tag
            end
    
            desc "Add a tag to an article"
            post do
              article = find_article(environment.articles, params[:id])
              article.tag_list=params[:tags]
              article.save
              present article.tag_list, :with => Entities::Tag
            end
    
          end
        end
  
      end
    end
  end
end
