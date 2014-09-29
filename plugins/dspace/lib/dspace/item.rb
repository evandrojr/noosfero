class Dspace::Item < Dspace::Resource

  def self.get_all_item_metadata_from(dspace_server, item_id)
    self.site = dspace_server
    result = self.find item_id, :params => { :expand => 'metadata' }
    result.metadata
  end

  def self.get_item_by_id(dspace_server, item_id)
    self.site = dspace_server
    result = self.find item_id, :params => { :expand => 'metadata' }

    item_metadata = Dspace::Item.get_all_item_metadata_from self.site, result.id

    # author
    metadata = item_metadata[0].attributes
    if metadata != {}
      metadata = Hash[[metadata.map{|k,v| v}]]
      author =  metadata.has_key?('dc.contributor.author') ? metadata['dc.contributor.author'] : nil
    end

    # issue date
    metadata = item_metadata[3].attributes
    if metadata != {}
      metadata = Hash[[metadata.map{|k,v| v}]]
      issue_date = metadata.has_key?('dc.date.issued') ? metadata['dc.date.issued'] : nil
    end

    # uri
    metadata = item_metadata[4].attributes
    if metadata != {}
      metadata = Hash[[metadata.map{|k,v| v}]]
      uri = metadata.has_key?('dc.identifier.uri') ? metadata['dc.identifier.uri'] : nil
    end

    # description
    metadata = item_metadata[5].attributes
    if metadata != {}
      metadata = Hash[[metadata.map{|k,v| v}]]
      abstract = metadata.has_key?('dc.description') ? metadata['dc.description'] : nil
    end

    # abstract
    metadata = item_metadata[6].attributes
    if metadata != {}
      metadata = Hash[[metadata.map{|k,v| v}]]
      description = metadata.has_key?('dc.description.abstract') ? metadata['dc.description.abstract'] : nil
    end

    item = DspacePlugin::Item.new

    item.id = result.id
    item.name = result.name
    item.author = author
    item.issue_date = issue_date
    item.abstract = abstract
    item.description = description
    item.uri = uri

    ### BITSTREAMS

    item_bitstreams = self.find item_id, :params => { :expand => 'bitstreams' }

    bitstreams = item_bitstreams.bitstreams

    bitstreams.each do |bs|
      bitstream = DspacePlugin::Bitstream.new
      bitstream.id = bs.attributes[:id]
      bitstream.name = bs.attributes[:name]
      bitstream.description = bs.attributes[:description]
      bitstream.mimetype = bs.attributes[:mimeType]
      bitstream.size_bytes = bs.attributes[:sizeBytes]
      bitstream.retrieve_link = bs.attributes[:retrieveLink]
      bitstream.format = bs.attributes[:format]
      bitstream.link = bs.attributes[:link]

      item.files << bitstream

    end

    item

  end

end
