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
    true
  end

end