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
              scope = profile.nil? ? environment.articles.is_public : profile.articles.is_public
              scope = scope.where(:type => params[:type]) if params[:type] && !(params[:type] == 'Article')
              scope = scope.where(make_conditions_with_parameter(params))
              scope = scope.joins(:categories).where(:categories => {:id => params[:category_ids]}) if params[:category_ids].present?
              scope = scope.where('articles.children_count > 0') if params[:has_children].present?
              query = params[:query] || ""
              order = "more_recent"

              options = {:filter => order, :template_id => params[:template_id]}

              paginate_options = params.select{|k,v| [:page, :per_page].include?(k.to_sym)}.symbolize_keys
              paginate_options.each_pair{|k,v| v=v.to_i}
              paginate_options[:page]=1 if !paginate_options.keys.include?(:page)

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
