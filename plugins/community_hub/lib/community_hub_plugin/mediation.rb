class CommunityHubPlugin::Mediation < Article

  before_save do |mediation|
    mediation.advertise = false
    mediation.notify_comments = false
    nil
  end

  settings_items :profile_picture, :type => :string, :default => ""

  def self.timestamp
    "hub-mediation-#{(Time.now.to_f * 1000).to_i}"
  end

  def self.description
    _('Hub mediation')
  end

  def self.short_description
    _('Hub mediation')
  end

end
