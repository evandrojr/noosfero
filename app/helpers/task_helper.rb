module TaskHelper

  def task_email_template(description, email_templates, task, include_blank=true)
    return '' unless email_templates.present?

    content_tag(
      :div,
      labelled_form_field(description, select_tag("tasks[#{task.id}][task][email_template_id]", options_from_collection_for_select(email_templates, :id, :name), :include_blank => include_blank, 'data-url' => url_for(:controller => 'profile_email_templates', :action => 'show_parsed', :profile => profile.identifier))),
      :class => 'template-selection'
    )
  end

  def task_action action
    base_url = { action: action }
    url_for(base_url.merge(filter_params))
  end

  def filter_params
    filter_fields = ['filter_type', 'filter_text', 'filter_responsible', 'filter_tags']
    params.select {|filter| filter if filter_fields.include? filter }
  end

end
