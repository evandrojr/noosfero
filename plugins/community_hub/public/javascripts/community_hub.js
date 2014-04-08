var $ = jQuery;

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
}

function setMediationTimestamp() {
  var now = new Date().getTime();
  var timestamp = 'hub-mediation-' + now.toString();
  $("article_name").value = timestamp;
}

function loadPosts(section) {

  var url;
  var container; 

  switch(section) {
    case 'live':
      url = '/plugin/community_hub/public/newer_comments';
      container = $("#live-posts");
      break;
    case 'mediation':
      url = '/plugin/community_hub/public/newer_articles';
      container = $("#mediation-posts");
      break;
  }

  $.ajax({
    url: url,
    success: function(data) { 
      container.append(data);
    },
    error: function(ajax, stat, errorThrown) {
      console.log(stat);
    }
  });

}

function hub() {
  loadPosts('live');
  loadPosts('mediation');
}

function checkNewPosts() {
  var agora = new Date();
  console.log( 'checking news posts...' );
}

function toogleAutoScrolling() {
  alert($("#auto_scrolling").attr('checked'));
}

$(document).ready(function(){

  $("#auto_scrolling").click(function(){
    toogleAutoScrolling();
  });

  hub();
  checkNewPosts('live');

});

