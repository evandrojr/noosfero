class SerproCaptchaPlugin < Noosfero::Plugin

  def self.plugin_name
    _('Serpro captcha plugin')
  end

  def self.plugin_description
    _("Provide a plugin to Serpro's captcha infrastructure.")
  end

  def self.api_mount_points
    [SerproCaptchaPlugin::API ]
  end

end
