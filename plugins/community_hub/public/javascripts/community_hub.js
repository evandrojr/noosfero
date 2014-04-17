var latest_post_id = 0;
var oldest_post_id = 0;
live_scroll_position = 0;

function clearLoadingMediationCommentSignal(mediation) {
 jQuery(".loading-mediation-comment").filter("#" + mediation).removeClass("loading-signal-error");
 jQuery(".loading-mediation-comment").filter("#" + mediation).removeClass("loading-signal-done");
}

function clearLoadingMessageSignal() {
 jQuery("#loading-message").removeClass("loading-signal-error");
 jQuery("#loading-message").removeClass("loading-signal-done");
}

function clearLoadingMediationSignal() {
 jQuery("#loading-mediation").removeClass("loading-signal-error");
 jQuery("#loading-mediation").removeClass("loading-signal-done");
}

function toogle_mediation_comments(mediation) {
  jQuery("#mediation-comment-list-" + mediation ).toggle();
  jQuery("#mediation-comment-form-" + mediation ).toggle();
}


function new_mediation_comment(button, mediation) {
  var form = jQuery(button).parents("form");

  jQuery(".loading-mediation-comment").filter("#" + mediation).addClass("loading-signal-processing");

  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    jQuery(".loading-mediation-comment").filter("#" + mediation).removeClass("loading-signal-processing");
    if (data.ok) {
      jQuery("#mediation-comment-form-" + mediation + " textarea").val('');
      jQuery(".loading-mediation-comment").filter("#" + mediation).addClass("loading-signal-done");
      update_mediation_comments(mediation);
      setTimeout(function(){
        clearLoadingMediationCommentSignal(mediation);
      }, 3000);
    }
    else {
      jQuery(".loading-mediation-comment").filter("#" + mediation).addClass("loading-signal-error");
      setTimeout(clearLoadingMessageSignal, 3000);
    }
  }, 'json');

}


function new_message(button) {
  var form = jQuery(button).parents("form");

  jQuery("#loading-message").addClass("loading-signal-processing");

  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    jQuery("#loading-message").removeClass("loading-signal-processing");
    if (data.ok) {
      jQuery(".hub .form #message_body").val('');
      jQuery("#loading-message").addClass("loading-signal-done");
      update_live_stream();
      setTimeout(clearLoadingMessageSignal, 3000);
    }
    else {
      jQuery("#loading-message").addClass("loading-signal-error");
      setTimeout(clearLoadingMessageSignal, 3000);
    }
  }, 'json');

}


function new_mediation(button) {
  var form = jQuery(button).parents("form");

  jQuery("#loading-mediation").addClass("loading-signal-processing");

  tinymce.triggerSave();
  jQuery.post(form.attr("action"), form.serialize(), function(data) {
    jQuery("#loading-mediation").removeClass("loading-signal-processing");
    if (data.ok) {
      jQuery("#loading-mediation").addClass("loading-signal-done");
      tinymce.get('article_body').setContent('');
      update_mediations();
      setTimeout(clearLoadingMediationSignal, 3000);
    }
    else {
      jQuery("#loading-mediation").addClass("loading-signal-error");
      setTimeout(clearLoadingMediationSignal, 3000);
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
        console.log(stat);
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
        console.log(stat);
      }
    });

  }

}


function update_mediation_comments(mediation) {

  if (jQuery("#right-tab.show").size() != 0) {

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
        console.log(stat);
      }
    });

  }

  setTimeout(function() { update_mediation_comments(mediation); }, 5000);
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
        console.log(stat);
      }
    });

  }

  setTimeout(update_mediations, 5000);
}


function update_live_stream() {

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
        }
      },
      error: function(ajax, stat, errorThrown) {
        console.log(stat);
      }
    });

  }

  setTimeout(update_live_stream, 5000);
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
  jQuery(".hub #left-tab.hide").click(hub_left_tab_click);
}

function marcelo() {
  console.log('teste!');
}

jQuery(document).ready(function() {
  jQuery("#live-posts").scroll(function() {
    live_scroll_position = jQuery("#live-posts").scrollTop();
  });

  jQuery(".hub #right-tab.hide").click(hub_right_tab_click);

  setTimeout(update_live_stream, 5000);
  setTimeout(update_mediations, 5000);
});
