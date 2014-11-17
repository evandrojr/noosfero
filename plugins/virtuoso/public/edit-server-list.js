function send_ajax(source_url) {
  jQuery(".server-address").autocomplete({
    source : function(request, response){
      jQuery.ajax({
        type: "GET",
        url: source_url,
        data: {query: request.term},
        success: function(result){
          response(result);
        },
        error: function(ajax, stat, errorThrown) {
          console.log('Server not found : ' + errorThrown);
        }
      });
    },

    minLength: 3
  });
}

function new_server_action(){
  send_ajax(jQuery("#page_url").val());

  jQuery(".delete-server-list-row").click(function(){
    jQuery(this).parent().parent().remove();
    return false;
  });

  jQuery(document).scrollTop(jQuery('#dropable-server-list').scrollTop());
}

function add_new_server() {
  var new_server = jQuery('#edit-server-list-block #new-template>li').clone();
  new_server.show();
  jQuery('#dropable-server-list').append(new_server);
  new_server_action();
}

jQuery(document).ready(function(){
  new_server_action();

  jQuery("#dropable-server-list").sortable({
    revert: true,
    axis: "y"
  });
});
