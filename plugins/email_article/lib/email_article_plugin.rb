class EmailArticlePlugin < Noosfero::Plugin

  def self.plugin_name
    "Email Article to Community Members Plugin"
  end

  def self.plugin_description
    _("A plugin that emails an article to the members of the community.")
  end

  def article_toolbar_extra_buttons
        lambda { 
          link_to_remote(_("Email article to members"),
                   {:url => { :controller => 'email_article_plugin_myprofile', :action => "send_email", :id => @page},
                   :method => :get
#                   , :loading => "Enviando emails" 
                 })
        }
  end
  
  def stylesheet?
    true
  end

end
