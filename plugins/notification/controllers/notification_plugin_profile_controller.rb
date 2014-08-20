class NotificationPluginProfileController < ProfileController
#  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  #FIXME make this test
#  needs_profile

  protect 'see_loby_notes', :profile

  layout 'embed'

  def lobby_notes
    @date = params[:date].nil? ? Date.today : Date.parse(params[:date])
    @events = profile.lobby_notes.by_day(@date).paginate(:per_page => per_page, :page => params[:page])

    if request.xhr?
      render :partial => 'event', :collection => @events
    end
  end

end

