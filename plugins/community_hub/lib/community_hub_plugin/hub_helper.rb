module CommunityHubPlugin::HubHelper

  def mediator?(hub)
    logged_in? && (user && hub.allow_edit?(user) || hub.mediators.include?(user.id))
  end

  def promoted?(hub, person)
    logged_in? && (hub.allow_edit?(person) || hub.mediators.include?(person.id))
  end

  def pinned_message?(hub, message_id)
    hub.pinned_messages.include?(message_id) ? true : false
  end

  def pinned_mediation?(hub, mediation_id)
    hub.pinned_mediations.include?(mediation_id) ? true : false
  end

  def post_time(time)
    _('%{hour}:%{minutes}') % { :hour => time.hour, :minutes => time.strftime("%M") } rescue ''
  end

end
