class DspacePluginController < PublicController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def view_item
    @collection = DspacePlugin::Collection.find(params[:collection_id])
    @item = Dspace::Item.get_item_by_id 6
  end

end
