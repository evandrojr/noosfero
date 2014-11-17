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

  def update_triple(graph_uri, from_triple, to_triple)
    from_subject = from_triple[:subject]
    from_predicate = from_triple[:predicate]
    from_object = format_triple_term(from_triple[:object])

    to_subject = to_triple[:subject]
    to_predicate = to_triple[:predicate]
    to_object = format_triple_term(to_triple[:object])

    query = "WITH <#{graph_uri}> DELETE { <#{from_subject}> <#{from_predicate}> #{from_object} } INSERT { <#{to_subject}> <#{to_predicate}> #{to_object} }"

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

  protected

  def format_triple_term(term)
    term =~ /^(http|https):\/\// ? "<#{term}>" : "'#{term}'"
  end

end
