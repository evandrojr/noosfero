class VirtuosoPlugin::TriplesTemplate < Article

  def self.short_description
    _('Triples template')
  end

  def self.description
    _('Triples template')
  end

  settings_items :query, :type => :string
  settings_items :template, :type => :string

  attr_accessible :query, :template

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
    results = plugin.virtuoso_client.query(query)
    liquid_template = Liquid::Template.parse("{% for row in results %}#{template}{% endfor %}")
    liquid_template.render('results' => results)
  end

end
