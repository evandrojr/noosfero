function is_valid_url(url) {
  var pattern =/^(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/i;
  return pattern.test(url);
}

function validate_search_form() {
  graph_uri = jQuery("input#graph_uri");
  query = jQuery("textarea#query");

  if ( !is_valid_url(graph_uri.val())) {
    alert( TRIPLES_MANAGEMENT_GRAPH_URI_REQUIRED_MESSAGE );
    graph_uri.focus();
    return false;
  }

  pattern = /.*select\s.*/i
  if (!pattern.test(query.val())) {
    alert( TRIPLES_MANAGEMENT_QUERY_REQUIRED_MESSAGE );
    query.focus();
    return false;
  }

  jQuery("#form-triples-search").submit();

}

function update_triple(triple_id) {
  graph = jQuery("input#graph_uri").val();

  from_subject = jQuery("input#triples_triple" + triple_id + "_from_subject").val();
  from_predicate = jQuery("input#triples_triple" + triple_id + "_from_predicate").val();
  from_object = jQuery("input#triples_triple" + triple_id + "_from_object").val();

  to_subject = jQuery("input#triples_triple" + triple_id + "_to_subject").val();
  to_predicate = jQuery("input#triples_triple" + triple_id + "_to_predicate").val();
  to_object = jQuery("input#triples_triple" + triple_id + "_to_object").val();

  var formData = {
    from_triple: { graph: graph, subject: from_subject, predicate: from_predicate, object: from_object },
    to_triple: { graph: graph, subject: to_subject, predicate: to_predicate, object: to_object }
  }

  jQuery.ajax({
    cache: false,
    type: 'POST',
    url: '/admin/plugin/virtuoso/update_triple',
    data: formData,
    dataType: 'json',
    success: function(data, status, ajax) {
      if ( !data.ok ) {
        display_notice(data.message);
      }
      else {
        display_notice(data.message);
        jQuery("input#triples_triple" + triple_id + "_from_object").val(jQuery("input#triples_triple" + triple_id + "_to_object").val());
      }
    }
  });

}

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
    success: function(data, status, ajax) {
      display_notice(data.message);
      jQuery.colorbox.close();
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
        display_notice(data.message);
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
    }
  });

  return false;
}
