class SerproIntegrationPlugin < Noosfero::Plugin

#include ActionController::UrlWriter
#  include ActionView::Helpers::TagHelper
#  include ActionView::Helpers::FormTagHelper
#  include FormsHelper


#  include ActionView::Helpers
#  include FormsHelper

  def self.plugin_name
    "Serpro Integration Plugin"
  end

  def self.plugin_description
    _("Make integration with serpro servers.")
  end

#  def filter_comment(c)
#    c.reject! unless logged_in? || allowed_by_profile
#  end

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

#  def body_beginning
#    "<meta name='profile.allow_unauthenticated_comments'/>" if allowed_by_profile
#  end
#
#  protected
#
#  delegate :logged_in?, :to => :context
#
#  def allowed_by_profile
#    context.profile && context.profile.allow_unauthenticated_comments
#  end

end
