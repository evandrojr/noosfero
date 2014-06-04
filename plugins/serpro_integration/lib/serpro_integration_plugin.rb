class SerproIntegrationPlugin < Noosfero::Plugin

  def self.plugin_name
    "Serpro Integration Plugin"
  end

  def self.plugin_description
    _("Make integration with serpro servers.")
  end

  #FIXME make this test
  # User could not have this block
  def self.extra_blocks
    { SonarPlugin::SonarWidgetBlock => {:type => [Community] },
      SonarPlugin::SmileBlock => {:type => [Community] } 
    }
  end

  #FIXME make this test
  def profile_editor_extras
   lambda do
      render :file => 'profile-editor-extras'
   end
  end

  def profile_id
    context.profile
  end

  def stylesheet?
    true
  end

# FIXME make this test
  def js_files
    ['smile_face.js']
  end

end
