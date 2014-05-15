class EmailArticlePlugin < Noosfero::Plugin

  def self.plugin_name
    "Email Article to Community Members Plugin"
  end

  def self.plugin_description
    _("A plugin that emails an article to the members of the community.")
  end

  def article_toolbar_extra_buttons
    label = _("Send article to members")
    htmlclass = _("button with-text icon-menu-mail")
    title = _("Email article to all community members")
    
    lambda {
      if  !profile.blank? and !user.blank? and user.is_admin?(profile) and @page.kind_of?(TextArticle) 
        link_to_remote(
            label,
            {
               :url => { :controller => 'email_article_plugin_myprofile', :action => "send_email", :id => @page},
               :method => :get,
               :success => "alert('Emails enviados')",
               :failure => "alert('Erro ao enviar email')",
               :confirm => _("Are you sure you want to email this article to the all community members?"),
            },
            :class => htmlclass,
            :title => title
         )
      end
    }
  end
end
