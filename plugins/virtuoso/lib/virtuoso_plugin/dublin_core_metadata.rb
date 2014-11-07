class VirtuosoPlugin::DublinCoreMetadata

  include OAI::XPath

  attr_accessor :date, :title, :creator, :subject, :description, :date, :type, :identifier, :language, :rights, :format

  def initialize(element)
    @title = xpath(element, './/dc:title')
    @creator = xpath(element, './/dc:creator')
    @subject = xpath_all(element, './/dc:subject').map(&:text)
    @description = xpath(element, './/dc:description')
    @date = xpath_all(element, './/dc:date').map(&:text)
    @type = xpath(element, './/dc:type')
    @identifier = xpath(element, './/dc:identifier')
    @language = xpath(element, './/dc:language')
    @rights = xpath_all(element, './/dc:rights').map(&:text)
    @format = xpath(element, './/dc:format')
  end

end
