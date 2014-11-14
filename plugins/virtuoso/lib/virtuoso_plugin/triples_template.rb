class VirtuosoPlugin::TriplesTemplate < Article

  def self.short_description
    _('Triples template')
  end

  def self.description
    _('Triples template')
  end

  def self.initial_template
    '
      {% for row in results %}
        <div>
          {{row}}
        </div>
      {% endfor %}
    '
  end

  settings_items :query, :type => :string
  settings_items :template, :type => :string, :default => initial_template
  settings_items :stylesheet, :type => :string

  attr_accessible :query, :template, :stylesheet

  def to_html(options = {})
    article = self
    proc do
      render :file => 'content_viewer/triples_template', :locals => {:article => article}
    end
  end

  def plugin
    @plugin ||= VirtuosoPlugin.new(self)
  end

  def template_content
    begin
      results = plugin.virtuoso_client.query(query)
      liquid_template = Liquid::Template.parse(template)
      page = liquid_template.render('results' => results)
      transform_html(page)
    rescue => ex
      logger.info ex.to_s
      "Failed to process the template"
    end
  end

  protected

  def transform_html(html)
    document = Roadie::Document.new(html)
    document.add_css(stylesheet) if stylesheet.present?
    document.transform
  end

end
