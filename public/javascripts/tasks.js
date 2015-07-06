(function($) {

  /**
  * @class Task singleton created with module pattern
  */
  Task = (function(){

    var _showError = function(context,response){

      var errorIcon = $('<span/>',{
        'class':'ui-icon ui-icon-alert',
        style:'float: left; margin-right: .3em;'
      });

      var content = $('<p/>',{
        html:'<strong>'+response.message+'</strong>'
      }).prepend(errorIcon);

      var div = $('<div/>',{
          'class':'alert fg-state-error ui-state-error'
      }).append(content);

      context.element.parents('.task_box').before(div);

    };

    var _showSuccess = function(context,response){
      _addIcon(context,'ok');

      setTimeout(function(){
        $('.ok').parent().remove();
      },1000);
    };

    var _addIcon = function(context,className){
      $('.'+className).parent().remove();

      var item = $('<li/>',{
        'class':'inputosaurus-input tag-saved',
        html:'<i class="'+className+'"></i>'
      });

      if(className == 'ok'){
        $('.loading').parent().remove();
      }
      context.elements.input.parent().before(item);
    }

    return {

      /**
      * @see inputosaurus#_sendTags The 'this' context here is the jquery ui widget component
      */
      onAddTag: function(response){
        this.element.parents('.task_box')
                    .prev('.fg-state-error')
                    .remove();

        if(response.success){

          _showSuccess(this,response);
        }else{

          _showError(this,response);
        }
      },
      addIcon: _addIcon,
      showTags: function(cfg){

        jQuery('.filter-tags').inputosaurus({
          hideInput: true
        });

        $('#filter-add-tag').change(function(){

          if($(this).val() != ''){
            jQuery('.filter-tags').inputosaurus('addTags',$(this).children(':selected').text());
          }
        });

        jQuery('.tag-list').inputosaurus({
          autoCompleteSource: '/myprofile/'+cfg.profileIdentifier+'/tasks/search_tags',
          activateFinalResult: true,
          submitTags: {
            url:  '/myprofile/'+cfg.profileIdentifier+'/tasks/save_tags',
            beforeSend: function(){

              $('.ok').parent().remove();

              this.element.parents('.task_box')
                          .prev('.fg-state-error')
                          .remove();

              _addIcon(this,'loading');

              //Add loading here!
            },
            success: this.onAddTag
          }
        });

      }

    };

  })();

  $("input.task_accept_radio").click(function(){
    task_id = this.getAttribute("task_id");
    $('#on-accept-information-' + task_id).show('fast');
    $('#on-reject-information-' + task_id).hide('fast');
    $('#on-skip-information-'   + task_id).hide('fast');
  })

  $("input.task_reject_radio").click(function(){
    task_id = this.getAttribute("task_id");
    $('#on-accept-information-' + task_id).hide('fast');
    $('#on-reject-information-' + task_id).show('fast');
    $('#on-skip-information-'   + task_id).hide('fast');
  })

  $("input.task_skip_radio").click(function(){
    task_id = this.getAttribute("task_id");
    $('#on-accept-information-' + task_id).hide('fast');
    $('#on-reject-information-' + task_id).hide('fast');
    $('#on-skip-information-'   + task_id).show('fast');
  })

  // There is probably an elegant way to do this...
  $('#up-set-all-tasks-to').selectedIndex = 0;
  $('#down-set-all-tasks-to').selectedIndex = 0;

  $('#down-set-all-tasks-to').change(function(){
    value = $('#down-set-all-tasks-to').selected().val();
    up = $('#up-set-all-tasks-to')
    up.attr('value', value).change();
  })

  $('#up-set-all-tasks-to').change(function(){
    value = $('#up-set-all-tasks-to').selected().val();
    down = $('#down-set-all-tasks-to')
    down.attr('value', value);
    $('.task_'+value+'_radio').each( function(){
      if(!this.disabled){
        $(this).attr('checked', 'checked').click();
      }
    })
  })

  $('.task_title').css('margin-right', $('.task_decisions').width()+'px');
  $('.task_title').css('margin-left', $('.task_arrow').width()+'px');

})(jQuery)

function change_task_responsible(el) {
  jQuery.post($(el).data('url'), {task_id: $(el).data('task'),
                    responsible_id: $(el).val(),
                    old_responsible_id: $(el).data('old-responsible')}, function(data) {
    if (data.success) {
      $(el).effect("highlight");
      $(el).data('old-responsible', data.new_responsible.id);
    } else {
      $(el).effect("highlight", {color: 'red'});
    }
    if (data.notice) {
      display_notice(data.notice);
    }
  });
}
