class SerproIntegrationrPlugin::SonarWidgetBlock < Block

  #FIXME make this test
  AVAILABLE_WIDGETS = {
    'project_motion_chart' => 'Project Motion Chart',
    'timeline' => 'Timeline',
    'complexity' => 'Complexity'
  }

  #FIXME make this test. Make test for default widget
  settings_items :widget, :type => String, :default => 'timeline'

  def self.description
    _('Sonar Widgets')
  end

  def help
    _('This block adds sonar widgets on profile.')
  end

  #FIXME make this test
  def sonar_host
    self.owner.serpro_integration_plugin['host']
  end

  #FIXME make this test
  def sonar_project
    self.owner.serpro_integration_plugin['project']
  end

  #FIXME make this test
  def widget_url
    self.sonar_host + 'widget?id=' + self.widget + '&resource=' + self.sonar_project + '&metric1=complexity&metric2=ncloc'
  end

  #FIXME make this test
  def is_widget_well_formed_url?
    !self.widget_url.match(/http[s]?:\/\/[\w|.|\/]+\/widget\?id=[\w]+&resource=[\w|\W]+/).nil?
  end

  #FIXME make this test
  def widget_width
    case widget
      when 'project_motion_chart'
        '360px'
      when 'timeline'
        '100%'
      when 'complexity'
        '100%'
      else
        '300px'
    end
  end

  #FIXME make this test
  def widget_height
    case widget
      when 'project_motion_chart'
        '450px'
      when 'timeline'
        '205px'
      when 'complexity'
        '170px'
      else
        '300px'
    end
  end

  def content(args={})
# render this url
#http://sonar.serpro/widget?id=timeline&resource=br.gov.fazenda.coaf.siscoaf:siscoaf-parent&metric1=complexity&metric2=ncloc

    block = self

    lambda do
      render :file => 'sonar_widget_block', :locals => { :block => block }
    end

  end

end
