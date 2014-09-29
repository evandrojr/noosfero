class DspacePluginController < PublicController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def view_item

    collection_id = params[:collection_id]
    item_id = params[:id]

    begin
      @collection = DspacePlugin::Collection.find(collection_id)
    rescue ActiveRecord::RecordNotFound
      render_not_found
      return
    end

    begin
      dspace_server = @collection.parent.parent.dspace_server_url
      @item = Dspace::Item.get_item_by_id dspace_server, item_id
      rescue ActiveResource::UnauthorizedAccess
      render_not_found
      return
    end

    begin
      @collection = DspacePlugin::Collection.find(collection_id)
    rescue ActiveRecord::RecordNotFound
      render_not_found
      return
    end

  end

end
