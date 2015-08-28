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
  settings_items :per_page, :type => :integer, :default => 50

  attr_accessible :query, :template, :stylesheet

  def to_html(options = {})
    article = self
    proc do
      render :file => 'content_viewer/triples_template', :locals => {:article => article, :page => params[:npage]}
    end
  end

  def plugin
    @plugin ||= VirtuosoPlugin.new(self)
  end

  attr_reader :results

  def template_content(page=1)
    begin
      @results ||= plugin.virtuoso_readonly_client.query(query).paginate({:per_page => per_page, :page => page})
      liquid_template = Liquid::Template.parse(template)
      rendered_template = liquid_template.render('results'       => results,
                                                 'total_pages'   => results.total_pages,
                                                 'current_page'  => results.current_page,
                                                 'per_page'      => results.per_page,
                                                 'total_entries' => results.total_entries,
                                                 'page_offset'   => (results.current_page-1)*results.per_page)
      transform_html(rendered_template)
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
