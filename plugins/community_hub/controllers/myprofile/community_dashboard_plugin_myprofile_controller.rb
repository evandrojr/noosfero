class CommunityDashboardPluginMyprofileController < MyProfileController

  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  before_filter :allow_edit_dashboard, :only => :save_order

  def save_order
    dashboard = profile.articles.find(params[:dashboard])
    redirect_to dashboard.url
  end

  protected

  def allow_edit_dashboard
    render_access_denied unless profile.articles.find(params[:dashboard]).allow_edit?(user)
  end

end
