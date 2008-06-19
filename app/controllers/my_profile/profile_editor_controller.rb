class ProfileEditorController < MyProfileController

  protect 'edit_profile', :profile

  def index
    @pending_tasks = profile.tasks.pending.select{|i| user.has_permission?(i.permission, profile)}
  end

  helper :profile

  # edits the profile info (posts back)
  def edit
    @profile_data = profile
    if request.post?
      if profile.update_attributes(params[:profile_data])
        redirect_to :action => 'index'
      end 
    end
  end

  def enable
    @to_enable = profile
    if request.post? && params[:confirmation]
      unless @to_enable.update_attribute('enabled', true)
        flash[:notice] = _('%s was not enabled.') % @to_enable.name
      end
      redirect_to :action => 'index'
    end
  end

  def disable
    @to_disable = profile
    if request.post? && params[:confirmation]
      unless @to_disable.update_attribute('enabled', false)
        flash[:notice] = _('%s was not disabled.') % @to_disable.name
      end
      redirect_to :action => 'index'
    end
  end

end
