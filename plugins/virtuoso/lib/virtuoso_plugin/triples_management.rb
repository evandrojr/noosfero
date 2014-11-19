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

    plugin.virtuoso_client.query(query)
  end

  def add_triple(triple)
    query = "WITH <#{triple.graph}> INSERT { <#{triple.subject}> <#{triple.predicate}> #{triple.object} }"
    plugin.virtuoso_client.query(query)
  end

  def remove_triple(triple)
    query = "WITH <#{triple.graph}> DELETE { <#{triple.subject}> <#{triple.predicate}> #{triple.object} }"
    plugin.virtuoso_client.query(query)
  end

end
