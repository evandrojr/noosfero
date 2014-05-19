module PairwisePlugin::Helpers::ViewerHelper

  def pairwise_plugin_stylesheet
    plugin_style_sheet_path = PairwisePlugin.public_path('style.css')
    stylesheet_link_tag  plugin_style_sheet_path, :cache => "cache/plugins-#{Digest::MD5.hexdigest plugin_style_sheet_path.to_s}"
  end

  def choose_left_link(pairwise_content, question, prompt, embeded = false, source = nil, appearance_id = nil)
    link_target = {:controller => 'pairwise_plugin_profile',
          :profile => pairwise_content.profile.identifier,
          :action => 'choose', :id => pairwise_content.id,:question_id => question.id , :prompt_id => prompt.id,
          :choice_id => prompt.left_choice_id , :direction => 'left', :appearance_id => appearance_id}
     link_target.merge!(:embeded => 1) if embeded
     link_target.merge!(:source => source) if source
     loading_javascript = pairwise_spinner_show_function_call(pairwise_content) + pairwise_hide_skip_call(pairwise_content)
     link_to_remote prompt.left_choice_text,  :loading => loading_javascript, :url => link_target
  end

  def skip_vote_open_function(pairwise_content)
    link_to_function _('Skip vote'), "jQuery('#skip_vote_reasons_#{pairwise_content.id}').slideToggle()"
  end

  def skip_vote_link(pairwise_content, question, prompt, embeded = false, source = nil, appearance_id = nil, reason = nil)
    link_target = {:controller => 'pairwise_plugin_profile',
          :profile => pairwise_content.profile.identifier,
          :action => 'skip_prompt', :id => pairwise_content.id,:question_id => question.id , :prompt_id => prompt.id,
          :appearance_id => appearance_id}
     link_target.merge!(:embeded => 1) if embeded
     link_target.merge!(:source => source) if source
     link_target.merge!(:appearance_id => appearance_id) if appearance_id
     link_target.merge!(:reason => reason) if reason
     link_text = reason ? reason : _('Skip vote')
     if reason
        loading_javascript = pairwise_spinner_show_function_call(pairwise_content) + pairwise_hide_skip_call(pairwise_content)
        "<li class='skip_vote_item'>" +  link_to_remote(link_text, :loading => loading_javascript, :url => link_target) + "</li>"
     else
        link_to_remote(link_text,  link_target)
     end
  end

  def pairwise_spinner_id(pairwise_content)
    return "pairwise_spinner#{pairwise_content.id}"
  end
  def pairwise_spinner(pairwise_content)
    text = content_tag :h5, _('Processing... please wait.')
    content_tag :div, text, :class => "spinner", :id => pairwise_spinner_id(pairwise_content)
  end

  def pairwise_spinner_show_function_call(pairwise_content)
    pairwise_spinner_show_function_name(pairwise_content) + "();"
  end

  def pairwise_hide_skip_call(pairwise_content)
    "jQuery('#skip_vote_reasons_#{pairwise_content.id}').hide();"
  end

  def pairwise_spinner_show_function_name(pairwise_content)
    "jQuery('##{pairwise_spinner_id(pairwise_content)}').fadeIn"
  end


  def pairwise_spinner_hide_function_call(pairwise_content)
    pairwise_spinner_hide_function_name(pairwise_content) + "();"
  end

  def pairwise_spinner_hide_function_name(pairwise_content)
    "jQuery('##{pairwise_spinner_id(pairwise_content)}').fadeOut"
  end

  def pairwise_user_identifier(user)
     if user.nil?
      is_external_vote ? "#{params[:source]}-#{request.session_options[:id]}" : "participa-#{request.session_options[:id]}"
     else
       user.identifier
     end
   end

  def pairwise_embeded_code(pairwise_content)
    embeded_url = url_for({:controller => "pairwise_plugin_profile",
                                        :profile => pairwise_content.profile.identifier,
                                        :action => "prompt",
                                        :id => pairwise_content.id,
                                        :question_id => pairwise_content.question.id,
                                        :embeded => 1,
                                        :source => "SOURCE_NAME",
                                        :only_path => false})
    embeded_code = "<iframe src='#{embeded_url}' style='width:100%;height:400px'  frameborder='0' allowfullscreen ></iframe>"

    label = "<hr/>"
    label += content_tag :h5, _('Pairwise Embeded')
    textarea =  text_area_tag 'embeded_code', embeded_code, {:style => "width: 100%; background-color: #ccc; font-weight:bold", :rows => 7}
    hint = content_tag :quote, _("You can put this iframe in your site. Replace <b>source</b> param with your site address and make any needed adjusts in width and height.")
    label + textarea + hint + "<hr/>"
  end

  def choose_right_link(pairwise_content, question, prompt, embeded = false, source = nil, appearance_id = nil)
    link_target = { :controller => 'pairwise_plugin_profile',
          :profile => pairwise_content.profile.identifier,
          :action => 'choose', :id => pairwise_content.id,  :question_id => question.id , :prompt_id => prompt.id,
          :choice_id => prompt.right_choice_id , :direction => 'right' , :appearance_id => appearance_id}
    link_target.merge!(:embeded => 1) if embeded
    link_target.merge!(:source => source) if source
    loading_javascript = pairwise_spinner_show_function_call(pairwise_content) + pairwise_hide_skip_call(pairwise_content)
    link_to_remote prompt.right_choice_text, :loading => loading_javascript, :url => link_target
  end

  def pairwise_edit_link(label, pairwise_content)
    link_target = myprofile_path(:controller => :cms, :profile => pairwise_content.profile.identifier, :action => :edit, :id => pairwise_content.id)
    link_to label, link_target
  end

  def pairwise_result_link(label, pairwise_content, embeded = false, options = {})
    link_target = pairwise_content.result_url
    link_target.merge!(:embeded => 1) if embeded
    link_to  label, link_target, options
  end

  def pairwise_tab_remote_link(label, link_target, pairwise_content, embeded = false, options = {})
    link_target.merge!(:embeded => 1) if embeded
    loading_javascript = pairwise_spinner_show_function_call(pairwise_content) + pairwise_hide_skip_call(pairwise_content)
    link_to_remote label, :loading => loading_javascript, :url => link_target, :html => options
  end

  def pairwise_suggestion_url(question, embeded = false, source = nil)
    target =  { :controller => :pairwise_plugin_profile, :profile => question.profile.identifier,:action => 'suggest_idea', :id => question.id }
    target.merge!({ :embeded => 1 }) if embeded
    target.merge!({ :source => source }) if source
    target
  end

  def is_external_vote
    params.has_key?("source") && !params[:source].empty?
  end

  def ideas_management_link(label, pairwise_content, user)
    return "" unless user
    return "" unless pairwise_content.allow_edit?(user)
    link_to label, :controller => :pairwise_plugin_suggestions, :profile => pairwise_content.profile.identifier, :action => :index, :id => pairwise_content.id
  end

  def has_param_pending_choices?
    params.has_key?("pending") && "1".eql?(params[:pending])
  end

  def has_param_reproved_choices?
    params.has_key?("reproved") && "1".eql?(params[:reproved])
  end

  def choices_showing_text
    ideas_or_suggestions_text = has_param_pending_choices? ? "Suggestions" : "Ideas"
    _("Showing")  + " " + ideas_or_suggestions_text
  end

  def pairwise_span_arrow(index)
    content_tag :span, '', :class => (index == 0 ? 'active' : '')
  end

  def pairwise_group_row_classes(index)
    index == 0 ? 'row' : 'row secondary'
  end

  def pairwise_group_content_body(index, pairwise_content, prompt_id = nil)
    style = (index > 0) ? 'display:none' : ''
    content_tag :div, :class => "pairwise_inner_body", :id => "pairwise_inner_body_#{pairwise_content.id}", :style => style do
      render :partial => 'content_viewer/prompt_body',
        :locals => {
                    :embeded => params[:embeded],
                    :source => params[:source],
                    :pairwise_content => pairwise_content,
                    :question => nil
                  }
    end
  end
end

