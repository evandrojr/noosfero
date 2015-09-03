module Noosfero
  module API
    module V1
      class Search < Grape::API  

        resource :search do
          resource :article do
            paginate per_page: 20, max_per_page: 200
            get do
              # Security checks
              sanitize_params_hash(params) 
              # APIHelpers
              asset = :articles
              context = environment

              profile = environment.profiles.find(params[:profile_id]) if params[:profile_id]

              scope = profile.nil? ? environment.articles.public : profile.articles.public

              scope = scope.where(:type => params[:type]) if params[:type] && !(params[:type] == 'Article')
              
              category = params[:category] || ""

              query = params[:query] || ""             
              order = "more_recent"

              options = {:filter => order, :template_id => params[:template_id], :category => category}            

              search_result = find_by_contents(asset, context, scope, query, paginate_options, options)

              articles = search_result[:results]

              result = present_articles_paginated(articles)
              
              result
            end            
          end
        end

      end
    end
  end
end
