class PairwisePluginAdminController < AdminController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def index
    @settings ||= Noosfero::Plugin::Settings.new(environment, PairwisePlugin, params[:settings])
    if request.post?
      @settings.api_host = nil if @settings.api_host.blank?
      @settings.username = nil if @settings.username.blank?
      @settings.password = nil if @settings.password.blank?
      @settings.save!
      redirect_to :action => 'index'
    end
  end
end
