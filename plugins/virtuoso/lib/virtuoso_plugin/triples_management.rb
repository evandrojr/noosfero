class VirtuosoPlugin::TriplesManagement

  def initialize(environment)
    @environment = environment
  end

  attr_reader :environment

  def plugin
    @plugin ||= VirtuosoPlugin.new(self)
  end

  def search_triples(graph_uri, query_sparql)
    query = "WITH <#{graph_uri}> #{query_sparql}"
    plugin.virtuoso_client.query(query)
  end

  def update_triple(from_triple, to_triple)
    query = "WITH <#{from_triple.graph}> DELETE { <#{from_triple.subject}> <#{from_triple.predicate}> #{from_triple.object} } INSERT { <#{to_triple.subject}> <#{to_triple.predicate}> #{to_triple.object} }"

    begin
      query_result = plugin.virtuoso_client.query(query)[0][:"callret-0"].to_s
    rescue RDF::Virtuoso::Repository::MalformedQuery => e
      query_result = e.to_s
    end

    return query_result =~ /^Modify.*done$/ ? true : false
  end

  def add_triple(triple)
    query = "WITH <#{triple.graph}> INSERT { <#{triple.subject}> <#{triple.predicate}> #{triple.object} }"

    begin
      query_result = plugin.virtuoso_client.query(query)[0][:"callret-0"].to_s
    rescue RDF::Virtuoso::Repository::MalformedQuery => e
      query_result = e.to_s
    end

    return query_result =~ /^Insert.*done$/ ? true : false
  end

  def remove_triple(triple)
    query = "WITH <#{triple.graph}> DELETE { <#{triple.subject}> <#{triple.predicate}> #{triple.object} }"

    begin
      query_result = plugin.virtuoso_client.query(query)[0][:"callret-0"].to_s
    rescue RDF::Virtuoso::Repository::MalformedQuery => e
      query_result = e.to_s
    end

    return query_result =~ /^Delete.*done$/ ? true : false
  end

end
