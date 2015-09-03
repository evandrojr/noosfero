module Noosfero
  module API
    module V1
      class Search < Grape::API  

        resource :search do
          resource :article do
            get do
              # Security checks
              sanitize_params_hash(params) 
              # APIHelpers
              asset = :articles
              context = environment
              profile = environment.profiles.find(params[:profile_id]) if params[:profile_id]

              scope = profile.articles.public || scope = environment.articles.public

              scope = scope.where(:type => params[:type]) if params[:type] && !(params[:type] == 'Article')
              
              category = params[:category] || ""

              query = params[:query] || ""             
              order = "more_recent"

              options = {:filter => order, :template_id => params[:template_id], :category => category}            

              articles = find_by_contents(asset, context, scope, query, paginate_options, options)
              present articles
            end            
          end
        end

      end
    end
  end
end
