class NotificationPlugin::NotificationContent < Article

  def self.short_description
    'Notification for users'
  end

  def self.description
    'Notification for users of community'
  end

#FIXME make the html output specific
#  def to_html(options = {})
#    source = options["source"]
#    embeded = options.has_key? "embeded"
#    prompt_id = options["prompt_id"]
#    pairwise_content = self
#    lambda do
#      locals = {:pairwise_content =>  pairwise_content, :source => source, :embeded => embeded, :prompt_id => prompt_id }
#      render :file => 'content_viewer/prompt.rhtml', :locals => locals
#    end
#  end
#

end
