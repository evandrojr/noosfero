class Dspace::Resource < ActiveResource::Base

  %w(site).each do |attr|
    define_method(attr) do
      Thread.current["#{name}.active_resource.#{attr}"]
    end

    if attr.eql?('site')
      define_method("#{attr}=") do |site|
        @connection = nil
        site_uri = "http://localhost:8080/rest/"
        Thread.current["#{name}.active_resource.site"] = site_uri
      end
    end
  end

  class << self
    def element_path(id, prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
    end

    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
    end
  end

end
