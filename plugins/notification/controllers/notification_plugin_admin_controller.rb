class NotificationPluginAdminController < AdminController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  #FIXME create admin configuration for categories
  def index
    @settings ||= Noosfero::Plugin::Settings.new(environment, NotificationPlugin, params[:settings])
    if request.post?
      @settings.categories = nil if @settings.categories.blank?
      @settings.save!
      redirect_to :action => 'index'
    end
  end

  def create
    
#render :text => 'bli'
raise     params.inspect
  end

end
