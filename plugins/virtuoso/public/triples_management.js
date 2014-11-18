function add_triple() {
  graph = jQuery("input#triple_graph").val();
  subject = jQuery("input#triple_subject").val();
  predicate = jQuery("input#triple_predicate").val();
  object = jQuery("input#triple_object").val();

  var formData = { triple: { graph: graph, subject: subject, predicate: predicate, object: object } }

  jQuery.ajax({
    cache: false,
    type: 'POST',
    url: '/admin/plugin/virtuoso/add_triple',
    data: formData,
    dataType: 'json',
    success: function(data, status, ajax){
      if ( !data.ok ) {
        display_notice(data.error.message);
        jQuery.colorbox.close();
      }
      else {
        display_notice(data.message);
        jQuery.colorbox.close();
      }
    },
    error: function(ajax, status, errorThrown) {
      alert('Send request - HTTP '+status+': '+errorThrown);
    }
  });

  return false;
}

function remove_triple(triple_id) {
  graph = jQuery("input#graph_uri").val();
  subject = jQuery("input#triples_triple" + triple_id + "_from_subject").val();
  predicate = jQuery("input#triples_triple" + triple_id + "_from_predicate").val();
  object = jQuery("input#triples_triple" + triple_id + "_from_object").val();

  var formData = { triple: { graph: graph, subject: subject, predicate: predicate, object: object } }

  jQuery.ajax({
    cache: false,
    type: 'POST',
    url: '/admin/plugin/virtuoso/remove_triple',
    data: formData,
    dataType: 'json',
    success: function(data, status, ajax){
      if ( !data.ok ) {
        display_notice(data.error.message);
      }
      else {
        display_notice(data.message);
        jQuery("li#triple-" + triple_id).fadeOut(700, function() {
          if (jQuery("ul#triples-list > li").length == 1) {
            jQuery("form#form-triples-edit").remove();
          }
          else {
            jQuery("li#triple-" + triple_id).remove();
          }
        });
      }
    },
    error: function(ajax, status, errorThrown) {
      alert('Send request - HTTP '+status+': '+errorThrown);
    }
  });

  return false;
}
