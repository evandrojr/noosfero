module PairwisePlugin::Helpers::SuggestionsHelper

  def pagination_for_choices(choices)
    pagination_links choices,
      :params =>  {
                    :controller => 'pairwise_plugin_suggestions',
                    :action => :index,
                    :profile => profile.identifier
                  }
  end

  def link_to_sort_choices(pairwise_content, label, sort_by)

    sort_order = "asc"

    if params[:order]

      order = params[:order]

      if order[:sort_by] == sort_by
        case order[:sort_order]
          when 'asc'
            sort_order = 'desc'
          when 'desc'
            sort_order = 'asc'
          else
            sort_order = 'asc'
        end
      end

    end

    link_to label, :action => "index", :id => pairwise_content.id, :pending => params[:pending], :reproved => params[:reproved], :order => {:sort_by => sort_by, :sort_order => sort_order}
  end

  def class_to_order_column(title, order=nil)
    if order
      sort_by = title == order[:sort_by] ? "selected_column" : "not_selected_column"

      #raise sort_by.inspect

      case order[:sort_order]
        when 'asc'
          sort_order = "soDescending"
        when 'desc'
          sort_order = "soAscending"
        else
          sort_order = "soAscending"
      end

      if (title == order[:sort_by])
        style = "#{sort_by} #{sort_order}"
      else
        style = "#{sort_by}"
      end
    else
      style = "not_selected_column"
    end
  end

  def link_to_edit_choice(pairwise_content, choice)
    link_to _("Edit"), :action => "edit", :id => pairwise_content.id, :choice_id => choice.id
  end

  def link_to_approve_choice(pairwise_content, choice, params)
    link_to _("Approve"), :action => "approve", :id => pairwise_content.id, :choice_id => choice.id,:page => params[:page], :pending => params[:pending]
  end

   def link_to_reprove_idea(pairwise_content, choice, reason, params)
    link_to _("Reprove"), :action => "reprove", :reason => reason || 'reprove' , :id => pairwise_content.id, :choice_id => choice.id,:page => params[:page], :pending => params[:pending]
  end

end