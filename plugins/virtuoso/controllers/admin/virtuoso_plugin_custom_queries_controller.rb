class VirtuosoPluginCustomQueriesController < AdminController

  def index
    @custom_queries = environment.virtuoso_plugin_custom_queries.all
  end

  def new
    @custom_query = VirtuosoPlugin::CustomQuery.new
  end

  def edit
    @custom_query = VirtuosoPlugin::CustomQuery.find(params[:id])
  end

  def create
    @custom_query = VirtuosoPlugin::CustomQuery.new(params[:custom_query])
    @custom_query.environment = environment

    if @custom_query.save
      session[:notice] = _('Custom query was successfully created.')
      redirect_to :action => :index
    else
      render action: "new"
    end
  end

  def update
    @custom_query = VirtuosoPlugin::CustomQuery.find(params[:id])

    if @custom_query.update_attributes(params[:custom_query])
      session[:notice] = 'Custom query was successfully updated.'
      redirect_to :action => :index
    else
      render action: "edit"
    end
  end

  def destroy
    @custom_query = VirtuosoPlugin::CustomQuery.find(params[:id])
    @custom_query.destroy

    redirect_to :action => :index
  end

end
