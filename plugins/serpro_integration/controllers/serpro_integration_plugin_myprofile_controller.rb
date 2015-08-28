class SerproIntegrationPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def create_gitlab
    profile.create_gitlab_project
    render :update do |page|
      page.replace_html 'gitlab', :partial => 'gitlab'
#      page.replace_html 'gitlab', 'teste'
    end
#    raise 'teste my profile'
  end

end
