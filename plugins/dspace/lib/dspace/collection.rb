class Dspace::Collection < Dspace::Resource

  def self.get_all_items_from(dspace_server, collection_id)
    self.site = dspace_server
    result = self.find collection_id, :params => { :expand => 'items' }

    item_list = []

    if result.items.count > 0

      result.items.each { |element|

        item_metadata = Dspace::Item.get_all_item_metadata_from dspace_server, element.id

        # author
        metadata = item_metadata[0].attributes
        if metadata != {}
          metadata = Hash[[metadata.map{|k,v| v}]]
          author =  metadata.has_key?('dc.contributor.author') ? metadata['dc.contributor.author'] : nil
        end

        # date issued
        metadata = item_metadata[3].attributes
        if metadata != {}
          metadata = Hash[[metadata.map{|k,v| v}]]
          date_issued = metadata.has_key?('dc.date.issued') ? metadata['dc.date.issued'] : nil
        end

        item = DspacePlugin::Item.new

        item.id = element.id
        item.name = element.name
        item.author = author
        item.date_issued = date_issued

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
