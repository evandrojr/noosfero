class NotificationPluginProfileController < ProfileController
#  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  #FIXME make this test
#  needs_profile

  protect 'see_loby_notes', :profile

  def lobby_notes
    @date = params[:date].nil? ? Date.today : Date.parse(params[:date])
    @events = profile.lobby_notes.by_day(@date).paginate(:per_page => per_page, :page => params[:page])

    if request.xhr?
      render :partial => 'event', :collection => @events
    else
      render :file => 'notification_plugin_profile/lobby_notes', :layout => 'embed'
    end
  end

  def index
    @events = current_person.lobby_notes.find(:all, :conditions => {:profile => profile } )
    @event = NotificationPlugin::LobbyNoteContent.new
  end

  def create
    @event = NotificationPlugin::LobbyNoteContent.new(params[:event])
    @event.profile = profile
    @event.created_by = current_person
    @events = current_person.lobby_notes
    unless @event.save
      flash[:error] = _('Note not saved')
    end
    render :partial => 'event', :collection => @events
  end

  def notifications
    @date = params[:date].nil? ? Date.today : Date.parse(params[:date])

    if request.xhr?
      @event = NotificationPlugin::NotificationContent.new(params[:event])
      @event.profile = profile
      @event.created_by = current_person
      @event.save!
      
      @events = profile.notifications.paginate(:per_page => per_page, :page => params[:page])
      render :partial => 'event', :collection => @events
    else
      @events = profile.notifications.paginate(:per_page => per_page, :page => params[:page])
      render :file => 'notification_plugin_profile/notifications'
    end
  end
end

