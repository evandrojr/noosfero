class RDF::Query::Solution

  def to_liquid
    HashWithIndifferentAccess.new(to_hash)
  end

end
