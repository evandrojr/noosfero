var $ = jQuery;
var latest_post_id = 0;
var oldest_post_id = 0;


function hub_open_loading() {
  var html = '<div id="hub-loading">' +
               '<img src="/images/loading-small.gif" />' +
             '</div>';

   $('.hub .form .submit').after(html);
   $('#hub-loading').fadeIn('slow');
}


function hub_close_loading() {
  $('#hub-loading').fadeOut('slow', function() {
    $('#hub-loading').remove();
  });
}


function send_message_for_stream(button) {

  var $button = $(button);
  var form = $button.parents("form");

  hub_open_loading();

  $.post(form.attr("action"), form.serialize(), function(data) {
    console.log(data);
    $("#comment_body").val('');
    hub_close_loading();
  }, 'json');
}

function send_post_for_mediation(button) {
  var $ = jQuery;
  open_loading(DEFAULT_LOADING_MESSAGE);
  var $button = $(button);
  var form = $button.parents("form");
  $button.addClass('stream-post-button-loading');
  setMediationTimestamp();
  $.post(form.attr("action"), form.serialize(), function(data) {
    tinymce.get('article_body').setContent('');
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
  $("#article_name").val(timestamp);
  console.log('teste!!!!!!!!!!!');
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
  //checkNewPosts('live');
  //checkNewPosts('mediation');
}

function checkNewPosts(postType) {

  var url = '';
  var container;

  console.log(postType);

  switch (postType) {
    case 'live':
      url = '/plugin/community_hub/public/newer_comments';
      container = $("#live-posts");
      break;
    case 'mediation':
      url = '/plugin/community_hub/public/newer_articles';
      container = $("#mediation-posts");
      break;
  }

  var hub_id = $(".hub").attr('id');
  var now = new Date();

  $.ajax({
    url: url,
    type: 'get',
    data: { latest_post: latest_post_id, hub: hub_id },
    success: function(data) {

      if (data.trim().length > 0) {
        container.prepend(data);
        latest_post_id = $(".latest").attr("id");

      }
      else {
        console.log('No more live posts!');
      }

    },
    error: function(ajax, stat, errorThrown) {
      console.log(stat);
    }
  });

}

function toogleAutoScrolling() {
  alert($("#auto_scrolling").attr('checked'));
}

function setHubView(role) {

  var hub_id = $(".hub").attr('id');

  $.ajax({
    url: '/plugin/community_hub/public/set_hub_view',
    type: 'get',
    data: { hub: hub_id, role: role },
    success: function(data) {
      $(".form").html(data);
      console.log( data );
    },
    error: function(ajax, stat, errorThrown) {
      console.log( 'ERRO ao processar requisição!');
    }
  });

}


function checkUserLevel() {

  var hub_id = $(".hub").attr('id');

  $.ajax({
    url: '/plugin/community_hub/public/check_user_level',
    type: 'get',
    dataType: 'json',
    data: { hub: hub_id },
    success: function(data) {


      switch (data.level) {

        case -1:
          console.log( 'usuário não logado...' );
          setHubView('guest');
          break;
        case 0:
          console.log( 'usuário logado, visitante...');
          setHubView('visitor');
          break;
        case 1:
          console.log( 'usuário logado, mediador...');
          setHubView('mediator');
          break;
      }


    },
    error: function(ajax, stat, errorThrown) {
      console.log( 'ERRO ao processar requisição!');
    }
  });

}

$(document).ready(function(){

  $("#auto_scrolling").click(function(){
    toogleAutoScrolling();
  });

  hub();

  //checkUserLevel();

  //setInterval(checkNewLivePosts, 10000); //10 seconds interval
  setInterval(checkNewMediationPosts, 10000); //10 seconds interval
  //setInterval(checkUserLevel, 10000); //10 seconds interval

});


function checkNewLivePosts() {
  checkNewPosts('live');
}


function checkNewMediationPosts() {
  checkNewPosts('mediation'); 
}


function removeLivePost(post_id) {

  $.ajax({
    url: '/plugin/community_hub/public/remove_live_post',
    type: 'get',
    dataType: 'json',
    data: { id: post_id },
    success: function(data) {

      if (data.ok) {
        console.log( 'OK - Post removido!');  
      }
      else {
       console.log( 'NOT OK - Post NÃO removido!'); 
      }
      
    },
    error: function(ajax, stat, errorThrown) {
      console.log( 'ERRO ao processar requisição!');
    }
  });

}


function promoteLivePost(post_id, user_id) {

  var hub_id = $(".hub").attr('id');

  $.ajax({
    url: '/plugin/community_hub/public/promote_live_post',
    type: 'get',
    dataType: 'json',
    data: { id: post_id, user: user_id, hub: hub_id },
    success: function(data) {

      if (data.ok) {
        console.log( 'OK - Post promovido!');  
      }
      else {
       console.log( 'NOT OK - Post NÃO promovido!'); 
      }
      
    },
    error: function(ajax, stat, errorThrown) {
      console.log( 'ERRO ao processar requisição!');
    }
  });

}

function pinLivePost(post_id) {

  var hub_id = $(".hub").attr('id');

  $.ajax({
    url: '/plugin/community_hub/public/pin_live_post',
    type: 'get',
    dataType: 'json',
    data: { id: post_id, hub: hub_id },
    success: function(data) {

      if (data.ok) {
        console.log( 'OK - Post fixado!');  
      }
      else {
       console.log( 'NOT OK - Post NÃO fixado!'); 
      }
      
    },
    error: function(ajax, stat, errorThrown) {
      console.log( 'ERRO ao processar requisição!');
    }
  });

}

function likeLivePost(post_id) {

  $.ajax({
    url: '/plugin/community_hub/public/like_live_post',
    type: 'get',
    dataType: 'json',
    data: { id: post_id },
    success: function(data) {

      if (data.ok) {
        console.log( 'OK - Post curtido!');  
      }
      else {
       console.log( 'NOT OK - Post NÃO curtido!'); 
      }
      
    },
    error: function(ajax, stat, errorThrown) {
      console.log( 'ERRO ao processar requisição!');
    }
  });

}

function dislikeLivePost(post_id) {

  $.ajax({
    url: '/plugin/community_hub/public/dislike_live_post',
    type: 'get',
    dataType: 'json',
    data: { id: post_id },
    success: function(data) {

      if (data.ok) {
        console.log( 'OK - Post descurtido!');  
      }
      else {
       console.log( 'NOT OK - Post NÃO descurtido!'); 
      }
      
    },
    error: function(ajax, stat, errorThrown) {
      console.log( 'ERRO ao processar requisição!');
    }
  });

}