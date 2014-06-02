module CommunityHubPlugin::HubHelper

  def mediator?(hub)
    logged_in? && (hub.author.id == user.id || hub.mediators.include?(user.id)) ? true : false
  end

  def promoted?(hub, user_id)
    logged_in? && (hub.author.id == user_id || hub.mediators.include?(user_id)) ? true : false
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
