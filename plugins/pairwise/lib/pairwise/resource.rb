module Pairwise::Resource
  %w(site user password).each do |attr|               
    define_method(attr) do
      Thread.current["#{name}.active_resource.#{attr}"]
    end

    if attr.eql?('site')
      define_method("#{attr}=") do |site|
        @connection = nil
        site_uri = create_site_uri_from(site)
        Thread.current["#{name}.active_resource.site"] = site_uri
        Thread.current["#{name}.active_resource.user"] = URI.decode(site_uri.user) if site_uri.user
        Thread.current["#{name}.active_resource.password"]  = URI.decode(site_uri.password) if site_uri.password
      end
    else
      define_method("#{attr}=") do |val|
        @connection = nil
        Thread.current["#{name}.active_resource.#{attr}"] = val
      end
    end
  end
end