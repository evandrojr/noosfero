class Dspace::Collection < Dspace::Resource

  def self.get_all_items_from(dspace_server, collection_id)
    self.site = dspace_server
    result = self.find collection_id, :params => { :expand => 'items' }

    #if result.items.count > 0

    #  result.items.each { |item|

    #    item_metadata = Dspace::Item.get_all_item_metadata_from dspace_server, item.id
        #raise item_metadata.count.inspect
    #    raise item_metadata.inspect

    #  }
    #end

    result.items
  end

  def self.get_all_collections_from(dspace_server)
    self.site = dspace_server
    self.find(:all)
  end

end
