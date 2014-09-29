module DspacePlugin::ItemHelper

  def remove_slash_at_end_url(url)
    url.gsub!(/\/$/,'') if url =~ /\/$/
    url
  end

end
