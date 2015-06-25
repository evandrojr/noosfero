class TasksController < MyProfileController

  protect [:perform_task, :view_tasks], :profile, :only => [:index]
  protect :perform_task, :profile, :except => [:index]

  def index
    @filter_type = params[:filter_type].presence
    @filter_text = params[:filter_text].presence
    @filter_responsible = params[:filter_responsible]
    @task_types = Task.pending_types_for(profile)

    @tasks = Task.pending_all(profile, @filter_type, @filter_text).order_by('created_at', 'asc')
    @tasks = @tasks.where(:responsible_id => @filter_responsible.to_i != -1 ? @filter_responsible : nil) if @filter_responsible.present?
    @tasks = @tasks.paginate(:per_page => Task.per_page, :page => params[:page])

    @failed = params ? params[:failed] : {}

    @responsible_candidates = profile.members.by_role(profile.roles.reject {|r| !r.has_permission?('perform_task')}) if profile.organization?

    @view_only = !current_person.has_permission?(:perform_task, profile)
  end

  def processed
    @filter_requestor = params[:filter_requestor].presence
    @filter_type = params[:filter_type].presence
    @filter_text = params[:filter_text].presence
    @filter_status = params[:filter_status].presence
    @filter_created_from = Date.parse(params[:filter_created_from]) unless params[:filter_created_from].blank?
    @filter_created_until = Date.parse(params[:filter_created_until]) unless params[:filter_created_until].blank?
    @filter_closed_from = Date.parse(params[:filter_closed_from]) unless params[:filter_closed_from].blank?
    @filter_closed_until = Date.parse(params[:filter_closed_until]) unless params[:filter_closed_until].blank?

    @tasks = Task.to(profile).without_spam.closed.order('tasks.created_at DESC')
    @tasks = @tasks.of(@filter_type)
    @tasks = @tasks.where(:status => params[:filter_status]) unless @filter_status.blank?
    @tasks = @tasks.where('tasks.created_at >= ?', @filter_created_from.beginning_of_day) unless @filter_created_from.blank?
    @tasks = @tasks.where('tasks.created_at <= ?', @filter_created_until.end_of_day) unless @filter_created_until.blank?
    @tasks = @tasks.joins(:requestor).like('profiles.name', @filter_requestor) unless @filter_requestor.blank?
    @tasks = @tasks.like('tasks.data', @filter_text) unless @filter_text.blank?

    @tasks = @tasks.paginate(:per_page => Task.per_page, :page => params[:page])

    @task_types = Task.closed_types_for(profile)
  end

  def change_responsible
    task = profile.tasks.find(params[:task_id])

    if task.responsible.present? && task.responsible.id != params[:old_responsible_id].to_i
      return render :json => {:notice => _('Task already assigned!'), :success => false, :current_responsible => task.responsible.id}
    end

    responsible = profile.members.find(params[:responsible_id]) if params[:responsible_id].present?
    task.responsible = responsible
    task.save!
    render :json => {:notice => _('Task responsible successfully updated!'), :success => true, :new_responsible => {:id => responsible.present? ? responsible.id : nil}}
  end

  VALID_DECISIONS = [ 'finish', 'cancel', 'skip' ]

  def close
    failed = {}

    if params[:tasks]
      params[:tasks].each do |id, value|
        decision = value[:decision]
        if request.post? && VALID_DECISIONS.include?(decision) && id && decision != 'skip'
          task = profile.find_in_all_tasks(id)
          begin
            task.update_attributes(value[:task])
            task.send(decision, current_person)
          rescue Exception => ex
            message = "#{task.title} (#{task.requestor ? task.requestor.name : task.author_name})"
            failed[ex.message] ? failed[ex.message] << message : failed[ex.message] = [message]
          end
        end
      end
    end

    url = { :action => 'index' }
    if failed.blank?
      session[:notice] = _("All decisions were applied successfully.")
    else
      session[:notice] = _("Some decisions couldn't be applied.")
      url[:failed] = failed
    end
    redirect_to url
  end

  def new
    @ticket = Ticket.new(params[:ticket])
    if params[:target_id]
      @ticket.target = profile.friends.find(params[:target_id])
    end
    @ticket.requestor = profile
    if request.post?
      if @ticket.save
        redirect_to :action => 'index'
      end
    end
  end

  def list_requested
    @tasks = Task.without_spam.find_all_by_requestor_id(profile.id)
  end

  def ticket_details
    @ticket = Ticket.find(:first, :conditions => ['(requestor_id = ? or target_id = ?) and id = ?', profile.id, profile.id, params[:id]])
  end

end
