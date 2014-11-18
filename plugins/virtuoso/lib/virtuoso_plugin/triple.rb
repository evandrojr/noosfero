class VirtuosoPlugin::Triple

  attr_accessor :graph, :subject, :predicate, :object

  def object=(value)
    @object = format_triple_term(value)
  end

  protected

  def format_triple_term(term)
    term =~ /^(http|https):\/\// ? "<#{term}>" : "'#{term}'"
  end

end

