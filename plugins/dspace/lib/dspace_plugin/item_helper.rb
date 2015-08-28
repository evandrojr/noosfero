module DspacePlugin::ItemHelper

  TEXT_MIMETYPES = [ 'text/plain; charset=utf-8',
                     'text/html',
                     'text/xml',
                     'text/plain',
                     'text/html',
                     'text/css',
                     'text/richtext' ]

  AUDIO_MIMETYPES = [ 'audio/x-pn-realaudio',
                      'audio/x-mpeg',
                      'audio/x-aiff',
                      'audio/basic',
                      'audio/x-wav' ]

  DOCUMENT_MIMETYPES = [ 'application/msword',
                         'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                         'application/vnd.oasis.opendocument.text',
                         'application/vnd.oasis.opendocument.text-template',
                         'application/vnd.oasis.opendocument.text-web',
                         'application/vnd.oasis.opendocument.text-master',
                         'application/vnd.sun.xml.writer',
                         'application/vnd.sun.xml.writer.template',
                         'application/vnd.sun.xml.writer.global',
                         'application/vnd.stardivision.writer',
                         'application/vnd.stardivision.writer-global' ]

  PICTURE_MIMETYPES = [  'image/x-photo-cd',
                         'image/x-ms-bmp',
                         'image/jpeg',
                         'image/gif',
                         'image/png',
                         'image/tiff',
                         'application/x-photoshop',
                         'application/postscript' ]

  SPREADSHEET_MIMETYPES = [ 'application/vnd.ms-excel',
                            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                            'application/vnd.oasis.opendocument.spreadsheet',
                            'application/vnd.oasis.opendocument.spreadsheet-template',
                            'application/vnd.sun.xml.calc',
                            'application/vnd.sun.xml.calc.template',
                            'application/vnd.sun.xml.math',
                            'application/vnd.stardivision.calc' ]

  VIDEO_MIMETYPES = [ 'video/quicktime',
                      'video/mpeg' ]


  def remove_slash_at_end_url(url)
    url.gsub!(/\/$/,'') if url =~ /\/$/
    url
  end

  def class_for_item_mimetype(mimetype)

    case

      when mimetype == 'application/pdf'
        mimetype_class = 'pdf'

      when TEXT_MIMETYPES.include?(mimetype)
        mimetype_class = 'text'

      when AUDIO_MIMETYPES.include?(mimetype)
        mimetype_class = 'audio'

      when DOCUMENT_MIMETYPES.include?(mimetype)
        mimetype_class = 'document'

      when PICTURE_MIMETYPES.include?(mimetype)
        mimetype_class = 'picture'

      when SPREADSHEET_MIMETYPES.include?(mimetype)
        mimetype_class = 'spreadsheet'

      when VIDEO_MIMETYPES.include?(mimetype)
        mimetype_class = 'video'

      else
        mimetype_class = 'other'

    end

    "icon-#{mimetype_class}"

  end

end
