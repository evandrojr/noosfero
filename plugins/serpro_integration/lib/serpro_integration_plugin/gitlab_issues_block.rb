require 'open-uri'
require 'json'

class SerproIntegrationPlugin::GitlabIssuesBlock < Block

  def self.description
    _('Gitlab Issues')
  end

  def help
    _('This block list gitlab issues')
  end

  #FIXME make this test
  def content(args={})
    gitlab_integration = SerproIntegrationPlugin::GitlabIntegration.new(owner.gitlab_host, owner.gitlab_private_token)
    issues = gitlab_integration.issues(owner)
    block = self
    proc do
      render :file => 'blocks/gitlab_issues', :locals => {:issues => issues, :block => block}
    end
    #content_tag(:div,
    #  content_tag(:canvas, '', :id => smile_face_id, :width => '95%', :height => '95%' ) +
    #  "<script type='text/javascript'>drawFace('#{smile_face_id}', '#{self.smile_factor}')</script>",
    #  :class => 'smile'
    #)
  end

  def cacheable?
    false
  end

end
