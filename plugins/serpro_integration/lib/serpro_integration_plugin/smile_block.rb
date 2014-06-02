require 'open-uri'
require 'json'

class SonarPlugin::SmileBlock < Block


  METRIC_SUCCESS_DENSITY = 'test_success_density'
  METRIC_LOC = 'ncloc'
  METRIC_UNCOVERED_LINE = 'uncovered_lines'
  METRIC_COVERAGE = 'coverage'

  #FIXME make this test
  settings_items :sonar_info, :type => Hash, :default => {}

  def self.description
    _('Sonar Smile')
  end

  def help
    _('This block adds a smile face that make tecnical debits visible with funny way.')
  end

  #FIXME make this test
  def sonar_host
    self.owner.sonar_plugin['host']
  end

  #FIXME make this test
  def sonar_project
    self.owner.sonar_plugin['project'] #|| ''
  end

#FIXME make this test
  def smile_factor
    collect_sonar_information
    factor = (self.sonar_info[METRIC_COVERAGE] * self.sonar_info[METRIC_SUCCESS_DENSITY]).to_f/1000
    factor
  end

  #FIXME make this test
  def content(args={})
    smile_face_id = 'smileFace-' + self.id.to_s

    content_tag(:div, 
      content_tag(:canvas, '', :id => smile_face_id, :width => '95%', :height => '95%' ) +
      "<script type='text/javascript'>drawFace('#{smile_face_id}', '#{self.smile_factor}')</script>",
      :class => 'smile'
    )
  end

  #FIXME make this test
  def self.metrics
    [
      METRIC_SUCCESS_DENSITY, 
      METRIC_LOC, 
      METRIC_UNCOVERED_LINE, 
      METRIC_COVERAGE
    ]
  end

  private

 #FIXME make this test
  def collect_sonar_information
    return false unless cache_expired?
    begin
      data =  open("#{self.sonar_host}/api/resources?resource=#{self.sonar_project}&metrics=ncloc,coverage,weighted_violations,uncovered_lines,test_success_density&format=json").read
      self.sonar_info = parse_sonar_resource(JSON.parse(data).first)
    rescue
      self.sonar_info = {}
    end
    self.sonar_info[:updated_at] = Time.now
    self.save
  end

  #FIXME make this test
  def parse_sonar_resource(data)
    parsed_data = {}
    return {} if data['msr'].nil?
    data['msr'].map do |metric|
      self.class.metrics.map do |defined_metric|
        parsed_data[defined_metric] = metric['val'] if metric['key'] == defined_metric
      end
    end
    parsed_data
  end

  #FIXME make this test
  def cache_expired?
    return true if self.sonar_info[:updated_at].nil?
    (Time.now - self.sonar_info[:updated_at]) > cache_timestamp
  end

  #FIXME make this test
  # Cach time to load new data in seconds
  def cache_timestamp
     60 * 60
  end

end
