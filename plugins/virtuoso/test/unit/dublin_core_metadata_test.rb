require File.dirname(__FILE__) + '/../test_helper'

class DublinCoreMetadataTest < ActiveSupport::TestCase

  should 'parse default dublin core fields' do
    dc = VirtuosoPlugin::DublinCoreMetadata.new(metadata)
    assert_equal "Title", dc.title
    assert_equal "Creator", dc.creator
    assert_equal ["Subject", "Other Subject"], dc.subject
    assert_equal "Description", dc.description
    assert_equal "2014", dc.date
    assert_equal "Type", dc.type
    assert_equal "Identifier", dc.identifier
    assert_equal "Language", dc.language
    assert_equal "Rights", dc.rights
    assert_equal "Format", dc.format
  end

  should 'extract fields' do
    dc = VirtuosoPlugin::DublinCoreMetadata.new(metadata)
    assert_equal "Title", dc.extract_field('dc:title')
    assert_equal "Creator", dc.extract_field('dc:creator')
    assert_equal ["Subject", "Other Subject"], dc.extract_field('dc:subject')
  end

  should 'return nil when field do not exists' do
    dc = VirtuosoPlugin::DublinCoreMetadata.new(metadata)
    assert_equal nil, dc.extract_field('dc:undefinedField')
  end

  def metadata
    REXML::Document.new('
      <metadata>
        <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/">
          <dc:title>Title</dc:title>
          <dc:creator>Creator</dc:creator>
          <dc:subject>Subject</dc:subject>
          <dc:subject>Other Subject</dc:subject>
          <dc:description>Description</dc:description>
          <dc:date>2014</dc:date>
          <dc:type>Type</dc:type>
          <dc:identifier>Identifier</dc:identifier>
          <dc:language>Language</dc:language>
          <dc:rights>Rights</dc:rights>
          <dc:format>Format</dc:format>
        </oai_dc:dc>
      </metadata>
    ')
  end

end
