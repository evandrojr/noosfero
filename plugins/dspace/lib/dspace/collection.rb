class Dspace::Collection < Dspace::Resource

  def self.get_all_items_from(dspace_server, collection_id)
    self.site = dspace_server
    result = self.find collection_id, :params => { :expand => 'items' }

    item_list = []

    if result.items.count > 0
      result.items.each { |element|
        item = Dspace::Item.get_item_by_id dspace_server, element.id
        item_list << item
      }
    end

    item_list
  end

  def self.get_all_collections_from(dspace_server)
    self.site = dspace_server
    self.find(:all)
  end

end
