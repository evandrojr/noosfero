class VirtuosoPlugin::DublinCoreMetadata

  include OAI::XPath

  FIELDS = ['title', 'creator', 'subject', 'description', 'date',
            'type', 'identifier', 'language', 'rights', 'format']

  def initialize(element)
    @element = element
    FIELDS.each do |field|
      self.class.send(:attr_accessor, field)
      self.send("#{field}=", extract_field("dc:#{field}"))
    end
  end

  def extract_field(name)
    value = xpath_all(@element, ".//#{name}")
    case value.size
    when 0
      nil
    when 1
      value.first.text
    else
      value.map { |v| v.respond_to?(:text) ? v.text : v}
    end
  end

end
