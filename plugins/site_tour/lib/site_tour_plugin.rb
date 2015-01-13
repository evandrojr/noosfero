class SiteTourPlugin < Noosfero::Plugin

  def self.plugin_name
    'SiteTourPlugin'
  end

  def self.plugin_description
    _("A site tour to show users how to use the application.")
  end

  def stylesheet?
    true
  end

  def js_files
    ['intro.min.js', 'main.js']
  end

  def user_data_extras
    proc do
      logged_in? ? {:site_tour_plugin_actions => user.site_tour_plugin_actions}:{}
    end
  end

  def body_ending
    proc do
      tour_file = "/plugins/site_tour/tour/#{language}/tour.js"
      if File.exists?(Rails.root.join("public#{tour_file}").to_s)
        javascript_include_tag(tour_file)
      else
        ""
      end
    end
  end

end
