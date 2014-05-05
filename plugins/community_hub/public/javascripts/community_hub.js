var latest_post_id = 0;
var oldest_post_id = 0;
live_scroll_position = 0;
var mediations = [];

function load_more(tab) {
  switch (tab) {
    case 'live':
      load_more_messages();
      break;
    case 'mediation':
      load_more_mediations();
      break;
  }
}


function load_more_mediations() {i
  // implement!
}

function load_more_messages() {
  var hub_id = jQuery(".hub").attr('id');
  var oldest_id = jQuery("#live-posts li.post").last().attr("id");

  jQuery.ajax({
    url: '/plugin/community_hub/public/older_comments',
    type: 'get',
    data: { oldest_id: oldest_id, hub: hub_id },
    success: function(data) {
      if (data.trim().length > 0) {
        jQuery("#live-posts").append(data);
      }
    },
    error: function(ajax, stat, errorThrown) {
    }
  });
}


function validate_textarea(txt) {
  return (txt.search(/[^\n\s]/)!=-1);
}


function toogle_mediation_comments(mediation) {
  jQuery("#mediation-comment-list-" + mediation ).toggle();
  jQuery("#mediation-comment-form-" + mediation ).toggle();
}


function new_mediation_comment(button, mediation) {

  if (!validate_textarea(jQuery("#mediation-comment-form-" + mediation + " textarea").val())) {
    return false;
  }

  for (var i = 0; i < mediations.length; i++) {
    mediation_id = mediations[i][0];
    if (mediation_id == mediation) {
      interval_id = mediations[i][1];
      clearInterval( interval_id );
      break;
    }

  }

  mediations.splice(i, 1);

  var form = jQuery(button).parents("form");

  jQuery("#mediation-comment-form-" + mediation + " .submit").attr("disabled", true);

  jQuery("body").addClass("hub-loading");

  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    jQuery("body").removeClass("hub-loading");
    if (data.ok) {
      jQuery("#mediation-comment-form-" + mediation + " textarea").val('');
      jQuery("#mediation-comment-form-" + mediation + " .submit").attr("disabled", false);
      update_mediation_comments(mediation, false);
      mediations.push( [ mediation, setInterval(function() { update_mediation_comments(mediation, false)}, 5000) ] );
    }
    else {
      jQuery("#mediation-comment-form-" + mediation + " .submit").attr("disabled", false);
      mediations.push( [ mediation, setInterval(function() { update_mediation_comments(mediation, false)}, 5000) ] );
    }
  }, 'json');

}


function new_message(button) {

  if (!validate_textarea(jQuery(".hub .form-message #message_body").val())) {
    return false;
  }

  var form = jQuery(button).parents("form");

  jQuery(".hub .form-message .submit").attr("disabled", true);

  jQuery("body").addClass("hub-loading");

  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    jQuery("body").removeClass("hub-loading");
    if (data.ok) {
      jQuery(".hub .form-message #message_body").val('');
      jQuery(".hub .form-message .submit").attr("disabled", false);
      update_live_stream(false);
    }
    else {
      jQuery(".hub .form-message .submit").attr("disabled", false);
    }
  }, 'json');

}


function new_mediation(button) {

  if (!validate_textarea(tinymce.get('article_body').getContent(''))) {
    return false;
  }

  var form = jQuery(button).parents("form");

  jQuery(".hub .form-mediation .submit").attr("disabled", true);

  jQuery("body").addClass("hub-loading");

  tinymce.triggerSave();
  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    jQuery("body").removeClass("hub-loading");
    if (data.ok) {
      jQuery(".hub .form-mediation .submit").attr("disabled", false);
      tinymce.get('article_body').setContent('');
      update_mediations();
    }
    else {
      jQuery(".hub .form-mediation .submit").attr("disabled", false);
    }
  }, 'json');

}


function promote_user(mediation, user_id) {

  if (confirm(DEFAULT_PROMOTE_QUESTION)) {

    var hub_id = jQuery(".hub").attr('id');

    jQuery.ajax({
      url: '/plugin/community_hub/public/promote_user',
      type: 'get',
      dataType: 'json',
      data: { user: user_id, hub: hub_id },
      success: function(data) {
        jQuery(".promote a").filter("#" + mediation).replaceWith( '<img class="promoted" src="/plugins/community_hub/icons/hub-not-promote-icon.png" title="User promoted">' );
      },
      error: function(ajax, stat, errorThrown) {
      }
    });

  }

}


function pin_message(post_id) {

  if (confirm(DEFAULT_PIN_QUESTION)) {

    var hub_id = jQuery(".hub").attr('id');

    jQuery.ajax({
      url: '/plugin/community_hub/public/pin_message',
      type: 'get',
      dataType: 'json',
      data: { message: post_id, hub: hub_id },
      success: function(data) {
        jQuery(".pin a").filter("#" + post_id).replaceWith( '<img class="pinned" src="/plugins/community_hub/icons/hub-not-pinned-icon.png" title="Message pinned">' );
      },
      error: function(ajax, stat, errorThrown) {
      }
    });

  }

}


function update_mediation_comments(mediation, recursive) {

  if (jQuery("#right-tab.show").size() != 0) {

    if (jQuery(".hub #mediation-comment-list-" + mediation).css('display') != "none") {

      var hub_id = jQuery(".hub").attr('id');

      if (jQuery("#mediation-comment-list-" + mediation + " li").first().length == 0) {
        var latest_post_id = 0;
      }
      else {
        var latest_post_id = jQuery("#mediation-comment-list-" + mediation + " li.mediation-comment").last().attr('id');
      }

      jQuery.ajax({
        url: '/plugin/community_hub/public/newer_mediation_comment',
        type: 'get',
        data: { latest_post: latest_post_id, mediation: mediation },
        success: function(data) {
          if (data.trim().length > 0) {
            jQuery("#mediation-comment-list-" + mediation + "").append(data);
            jQuery("#mediation-comment-total-" + mediation).html(jQuery("#mediation-comment-list-" + mediation + " li.mediation-comment").size());
          }
        },
        error: function(ajax, stat, errorThrown) {
        }
      });

    }

  }

  if (recursive) {
    setTimeout(function() {
       update_mediation_comments(mediation, true);
     }, 5000);
  }
}


function update_mediations() {

  if (jQuery("#right-tab.show").size() != 0) {

    var hub_id = jQuery(".hub").attr('id');

    if (jQuery("#mediation-posts li").first().length == 0) {
      var latest_post_id = 0;
    }
    else {
      var latest_post_id = jQuery("#mediation-posts li").first().attr('id');
    }

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
      }
    });

  }

  setTimeout(update_mediations, 10000);
}


function update_live_stream(recursive) {

  if (jQuery("#left-tab.show").size() != 0) {

    var hub_id = jQuery(".hub").attr('id');

    if (jQuery("#live-posts li").first().length == 0) {
      var latest_post_id = 0;
    }
    else {
      var latest_post_id = jQuery("#live-posts li").first().attr('id');
    }

    jQuery.ajax({
      url: '/plugin/community_hub/public/newer_comments',
      type: 'get',
      data: { latest_post: latest_post_id, hub: hub_id },
      success: function(data) {
        if (data.trim().length > 0) {
          jQuery("#live-posts").prepend(data);
          if (jQuery("#auto_scrolling").attr('checked')) {
            jQuery("#live-posts").scrollTop(0);
          }
          else {
            jQuery("#live-posts").scrollTop(live_scroll_position);
          }
          if (first_hub_load) {
            jQuery("body").removeClass("loading");
            first_hub_load = false;
          }
        }
      },
      error: function(ajax, stat, errorThrown) {
      }
    });

  }

  if (recursive) {
    setTimeout(function() {
      update_live_stream(true);
    }, 5000);
  }

}

function hub_left_tab_click() {
  jQuery("#right-tab").removeClass('show');
  jQuery("#right-tab").addClass('hide');
  jQuery("#left-tab").removeClass('hide');
  jQuery("#left-tab").addClass('show');
}

function hub_right_tab_click() {
  jQuery("#left-tab").removeClass('show');
  jQuery("#left-tab").addClass('hide');
  jQuery("#right-tab").removeClass('hide');
  jQuery("#right-tab").addClass('show');
  jQuery(".hub #right-tab.show h1.live").click(hub_left_tab_click);
}

first_hub_load = true;

jQuery(".hub .envelope").scroll(function() {
  jQuery("#auto_scrolling").attr('checked', false);

  // live stream tab...
  if (jQuery("#left-tab.show").size() != 0) {
    current_envelope = jQuery(".hub .live .envelope");
    current_list_posts = jQuery(".hub ul#live-posts");
    tab = 'live';
  }
  else {
    // mediation tab...
    if (jQuery("#right-tab.show").size() != 0) {
      current_envelope = jQuery(".hub .mediation .envelope");
      current_list_posts = jQuery(".hub ul#mediation-posts");
      tab = 'mediation';
    }
  }

  if (current_envelope.scrollTop() == (current_list_posts.height() - current_envelope.height() + 23)) {
    load_more(tab);
  }

});


jQuery(document).ready(function() {

  jQuery("#live-posts").scroll(function() {
    live_scroll_position = jQuery("#live-posts").scrollTop();
  });

  jQuery(".hub #left-tab.show h1.mediation").click(hub_right_tab_click);

  jQuery("body").addClass("loading");

  update_live_stream(true);
  update_mediations();

});
