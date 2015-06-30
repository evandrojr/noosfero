class TasksController < MyProfileController

  protect [:perform_task, :view_tasks], :profile, :only => [:index, :save_tags, :search_tags]
  protect :perform_task, :profile, :except => [:index, :save_tags, :search_tags]

  def index
    @email_templates = profile.email_templates.find_all_by_template_type(:task_rejection)

    @filter_type = params[:filter_type].presence
    @filter_text = params[:filter_text].presence
    @filter_responsible = params[:filter_responsible]
    @filter_tags = params[:filter_tags]

    @task_types = Task.pending_types_for(profile)
    @task_tags = [OpenStruct.new(:name => _('All'), :id => nil) ] + Task.all_tags

    @tasks = Task.pending_all(profile, @filter_type, @filter_text).order_by('created_at', 'asc')
    @tasks = @tasks.where(:responsible_id => @filter_responsible.to_i != -1 ? @filter_responsible : nil) if @filter_responsible.present?
    @tasks = @tasks.tagged_with(@filter_tags, any: true) if @filter_tags.present?
    @tasks = @tasks.paginate(:per_page => Task.per_page, :page => params[:page])

    @failed = params ? params[:failed] : {}

    @responsible_candidates = profile.members.by_role(profile.roles.reject {|r| !r.has_permission?('perform_task') && !r.has_permission?('view_tasks')}) if profile.organization?

    @view_only = !current_person.has_permission?(:perform_task, profile)
  end

  def processed
    @filter_requestor = params[:filter_requestor].presence
    @filter_closed_by = params[:filter_closed_by].presence
    @filter_type = params[:filter_type].presence
    @filter_text = params[:filter_text].presence
    @filter_status = params[:filter_status].presence
    @filter_created_from = Date.parse(params[:filter_created_from]) unless params[:filter_created_from].blank?
    @filter_created_until = Date.parse(params[:filter_created_until]) unless params[:filter_created_until].blank?
    @filter_closed_from = Date.parse(params[:filter_closed_from]) unless params[:filter_closed_from].blank?
    @filter_closed_until = Date.parse(params[:filter_closed_until]) unless params[:filter_closed_until].blank?

    @tasks = Task.to(profile).without_spam.closed.joins([:requestor, :closed_by]).order('tasks.created_at DESC')
    @tasks = @tasks.of(@filter_type)
    @tasks = @tasks.where(:status => params[:filter_status]) unless @filter_status.blank?
    @tasks = @tasks.where('tasks.created_at >= ?', @filter_created_from.beginning_of_day) unless @filter_created_from.blank?
    @tasks = @tasks.where('tasks.created_at <= ?', @filter_created_until.end_of_day) unless @filter_created_until.blank?
    @tasks = @tasks.like('profiles.name', @filter_requestor) unless @filter_requestor.blank?
    @tasks = @tasks.like('closed_bies_tasks.name', @filter_closed_by) unless @filter_closed_by.blank?

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
    save = false

    if params[:tasks]
      params[:tasks].each do |id, value|
        decision = value[:decision]

        if value[:task].is_a?(Hash) && value[:task][:tag_list]

          task = profile.find_in_all_tasks(id)
          task.tag_list = value[:task][:tag_list]
          value[:task].delete('tag_list')

          save = true
        end

        if request.post?
          if VALID_DECISIONS.include?(decision) && id && decision != 'skip'
            task ||= profile.find_in_all_tasks(id)
            begin
              task.update_attributes(value[:task])
              task.send(decision, current_person)
            rescue Exception => ex
              message = "#{task.title} (#{task.requestor ? task.requestor.name : task.author_name})"
              failed[ex.message] ? failed[ex.message] << message : failed[ex.message] = [message]
            end
          elsif save
            task.save!
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

  def search_tasks

    params[:filter_type] = params[:filter_type].blank? ? nil : params[:filter_type]
    result = Task.pending_all(profile,params)

    render :json => result.map { |task| {:label => task.data[:name], :value => task.data[:name]} }
  end

  def save_tags
    if request.post? && params[:tag_list]
      result = {
        success: false,
        message: _('Error to save tags. Please, contact the system admin')
      }

      ActsAsTaggableOn.remove_unused_tags = true

      task = Task.to(profile).find_by_id params[:task_id]
      save = user.tag(task, with: params[:tag_list], on: :tags)

      if save
        result[:success] = true
      end
    end

    render json: result
  end

  # FIXME make this test
  # Should not search for article tasks
  # Should not search for other profile tags
  # Should search only task tags
  # Should check the permissions

  def search_tags

    arg = params[:term].downcase

    result = ActsAsTaggableOn::Tag.find(:all, :conditions => ['LOWER(name) LIKE ?', "%#{arg}%"])

    render :text => prepare_to_token_input_by_label(result).to_json, :content_type => 'application/json'

  end

end
