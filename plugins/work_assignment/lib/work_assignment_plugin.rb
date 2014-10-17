class WorkAssignmentPlugin < Noosfero::Plugin

  def self.plugin_name
    "Work Assignment"
  end

  def self.plugin_description
    _("New kind of content for organizations.")
  end

  def self.can_download_submission?(user, submission)
    work_assignment = submission.parent.parent
    work_assignment.publish_submissions || (user && (submission.author == user || user.has_permission?('view_private_content', work_assignment.profile)))
  end

  def self.is_submission?(content)
    content && content.parent && content.parent.parent && content.parent.parent.kind_of?(WorkAssignmentPlugin::WorkAssignment)
  end

  def content_types
    [WorkAssignmentPlugin::WorkAssignment] if context.respond_to?(:profile) && context.profile.organization?
  end

  def stylesheet?
    true
  end

  def content_remove_new(content)
    content.kind_of?(WorkAssignmentPlugin::WorkAssignment)
  end

  def content_remove_upload(content)
    if content.kind_of?(WorkAssignmentPlugin::WorkAssignment)
      !content.profile.members.include?(context.send(:user))
    end
  end

  def content_viewer_controller_filters
    block = proc do
      path = params[:page]
      content = profile.articles.find_by_path(path)

      if WorkAssignmentPlugin.is_submission?(content) && !WorkAssignmentPlugin.can_download_submission?(user, content)
        render_access_denied
      end
    end

    { :type => 'before_filter',
      :method_name => 'work_assingment_only_admin_or_owner_download',
      :options => {:only => 'view_page'},
      :block => block }
  end

  def cms_controller_filters
    block = proc do
      @email_notification = params[:article_email_notification]
      if !@email_notification.nil? and @email_notification.include? "@" 
        @subject = "#{@parent.name} file submission"
        @email_contact = user.build_email_contact(:name => user.name, :subject => @subject, :email => user.email, :receiver => @email_notification, :sender => user)
        @email_contact.message = @email_contact.build_mail_message(environment, @uploaded_files, @parent.name)
        if @email_contact.deliver
          session[:notice] = _('Notification successfully sent')
        else
          session[:notice] = _('Notification not sent')
        end
      end
    end

    { :type => 'after_filter',
      :method_name => 'send_email_after_upload_file',
      :options => {:only => 'upload_files'},
      :block => block }
  end

  def article_extra_fields(article)
    proc do
        @article = Article.find_by_id(article)
        if params[:parent_id] && !@article.nil? && @article.type == "WorkAssignmentPlugin::WorkAssignment"
          render :partial => 'notify_text_field',  :locals => { :size => '45'} 
        end      
    end
  end

end