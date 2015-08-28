class RDF::Literal

  include ActionView::Helpers::SanitizeHelper

  def to_liquid
    strip_tags(value)
  end

end
