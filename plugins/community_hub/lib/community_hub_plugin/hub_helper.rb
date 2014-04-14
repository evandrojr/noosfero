module CommunityHubPlugin::HubHelper

  def post_css_classes(post_id, latest_post_id, oldest_post_id)
    classes = "post"

    if post_id == latest_post_id
      classes += " latest"
    end

    if post_id == oldest_post_id
      classes += " oldest"
    end

    classes
  end

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
    if time
      _('%{hour}:%{minutes}') % { :hour => time.hour, :minutes => time.strftime("%M") }
    else
      ''
    end
  end

  def embed_code(hub)
    "<iframe width='425' height='350' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='#{url_for(hub.url)}'></iframe>"
  end

end