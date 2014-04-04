function send_message_for_stream(button) {
  var $ = jQuery;
  open_loading(DEFAULT_LOADING_MESSAGE);
  var $button = $(button);
  var form = $button.parents("form");
  $button.addClass('stream-post-button-loading');
  $.post(form.attr("action"), form.serialize(), function(data) {
    if(data.render_target == null) {
    } 
    else if(data.render_target == 'form') {
    } 
    else if($('#' + data.render_target).size() > 0) {
    } 
    else {
      form.find("input[type='text']").add('textarea').each(function() {
        this.value = '';
      });
    }

    close_loading();
    $button.removeClass('stream-post-button-loading');
    $button.enable();
  }, 'json');
}

function teste() {
  alert('teste');
}

function send_post_for_mediation(button) {
  var $ = jQuery;
  open_loading(DEFAULT_LOADING_MESSAGE);
  var $button = $(button);
  var form = $button.parents("form");
  $button.addClass('stream-post-button-loading');
  $.post(form.attr("action"), form.serialize(), function(data) {
    if(data.render_target == null) {
    } 
    else if(data.render_target == 'form') {
    } 
    else if($('#' + data.render_target).size() > 0) {
    } 
    else {
      form.find("input[type='text']").add('textarea').each(function() {
        this.value = '';
      });
    }

    close_loading();
    $button.removeClass('stream-post-button-loading');
    $button.enable();
  });
}

function clearMediationForm(element) {
  alert(element);
  //var $field = $(field);
  //$field.value = '';
}


//setInterval(teste, 2000);
