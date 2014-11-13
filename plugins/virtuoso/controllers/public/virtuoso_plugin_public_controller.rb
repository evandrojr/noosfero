class VirtuosoPluginPublicController < PublicController

  def custom_query
    render :json => environment.virtuoso_plugin_custom_queries.find(params[:id])
  end

end
