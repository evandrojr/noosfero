class DspacePlugin::DspaceBlock < Block

  settings_items :dspace_server_url, :type => :string, :default => ""
  settings_items :collections, :type => :string, :default => ""

  attr_accessible :dspace_server_url, :collections

  def self.description
    _('DSpace library')
  end

  def help
    _('This block displays a DSpace content.')
  end

  def content(args={})
    block = self
    proc do
      dspace_client = Dspace::Client.new(block.dspace_server_url)
      collection_items = dspace_client.get_collection_items(block.collections)
      if !collection_items.blank?
        content_tag('div',
          render(:file => 'blocks/dspace', :locals => {:collection_items => collection_items})
        )
      else
        ''
      end
    end
  end

  def cacheable?
    false
  end

end
