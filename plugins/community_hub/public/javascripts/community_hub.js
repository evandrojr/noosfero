var latest_post_id = 0;
var oldest_post_id = 0;

function toogle_mediation_comments(mediation) {
  jQuery("#mediation-comment-list-" + mediation ).toggle();
  jQuery("#mediation-comment-form-" + mediation ).toggle();
}


function hub_open_loading(button) {
  var html = '<div id="hub-loading">' +
               '<img src="/images/loading-small.gif" />' +
             '</div>';

   //$('.hub .form .submit').after(html);
   jQuery(button).after(html);
   jQuery('#hub-loading').fadeIn('slow');
}


function hub_close_loading() {
  jQuery('#hub-loading').fadeOut('slow', function() {
    jQuery('#hub-loading').remove();
  });
}


function new_message(button) {
  var form = jQuery(button).parents("form");

  //hub_open_loading();
  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    if (data.ok) {
      jQuery("#message_body").val('');
    }
    //hub_close_loading();
  }, 'json');

}


function new_mediation(button) {
  var form = jQuery(button).parents("form");

  //hub_open_loading();
  tinymce.triggerSave();
  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    if (data.ok) {
      tinymce.get('article_body').setContent('');
    }
    //hub_close_loading();
  }, 'json');

}


function toogleAutoScrolling() {
  alert(jQuery("#auto_scrolling").attr('checked'));
}


function promote_user(user_id) {

  var hub_id = jQuery(".hub").attr('id');

  jQuery.ajax({
    url: '/plugin/community_hub/public/promote_user',
    type: 'get',
    dataType: 'json',
    data: { user: user_id, hub: hub_id },
    success: function(data) {
    },
    error: function(ajax, stat, errorThrown) {
      console.log(stat);
    }
  });

}


function pin_message(post_id) {

  var hub_id = jQuery(".hub").attr('id');

  jQuery.ajax({
    url: '/plugin/community_hub/public/pin_message',
    type: 'get',
    dataType: 'json',
    data: { id: post_id, hub: hub_id },
    success: function(data) {    
    },
    error: function(ajax, stat, errorThrown) {
      console.log(stat);
    }
  });

}


function update_mediation_comments(mediation) {
  var hub_id = jQuery(".hub").attr('id');

  if (jQuery("#mediation-comment-list-" + mediation + " li").first().length == 0) {
    var latest_post_id = 0;
  }
  else {
    var latest_post_id = jQuery("#mediation-comment-list-" + mediation + " li.mediation-comment").last().attr('id');
  }

  //console.log(latest_post_id);

  jQuery.ajax({
    url: '/plugin/community_hub/public/newer_mediation_comment',
    type: 'get',
    data: { latest_post: latest_post_id, mediation: mediation },
    success: function(data) {
      if (data.trim().length > 0) {
        jQuery("#mediation-comment-list-" + mediation + "").append(data);
      }
    },
    error: function(ajax, stat, errorThrown) {
      console.log(stat);
    }
  });

  setTimeout(function() { update_mediation_comments(mediation); }, 5000);
}


function update_mediations() {
  var hub_id = jQuery(".hub").attr('id');

  if (jQuery("#mediation-posts li").first().length == 0) {
    var latest_post_id = 0;
  }
  else {
    var latest_post_id = jQuery("#mediation-posts li").first().attr('id');
  }

  //console.log(latest_post_id);

  jQuery.ajax({
    url: '/plugin/community_hub/public/newer_articles',
    type: 'get',
    data: { latest_post: latest_post_id, hub: hub_id },
    success: function(data) {
      if (data.trim().length > 0) {
        jQuery("#mediation-posts").prepend(data);
      }
    },
    error: function(ajax, stat, errorThrown) {
      console.log(stat);
    }
  });

  setTimeout(update_mediations, 10000);  
}


function update_live_stream() {
  var hub_id = jQuery(".hub").attr('id');

  if (jQuery("#live-posts li").first().length == 0) {
    var latest_post_id = 0;
  }
  else {
    var latest_post_id = jQuery("#live-posts li").first().attr('id');
  }

  //console.log(latest_post_id);

  jQuery.ajax({
    url: '/plugin/community_hub/public/newer_comments',
    type: 'get',
    data: { latest_post: latest_post_id, hub: hub_id },
    success: function(data) {
      if (data.trim().length > 0) {
        jQuery("#live-posts").prepend(data);
      }
    },
    error: function(ajax, stat, errorThrown) {
      console.log(stat);
    }
  });

  setTimeout(update_live_stream, 5000);  
}


jQuery(document).ready(function() {
  setTimeout(update_live_stream, 5000);
  setTimeout(update_mediations, 10000);
});