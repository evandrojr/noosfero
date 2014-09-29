/**

function selectCommunity(element, community_slug) {
  var hidden_field = jQuery('<input>').attr({
      id: 'article_dspace_community_name_',
      name: 'article[dspace_communities_names][]',
      type: 'hidden',
      name: 'article[dspace_communities_names][]',
      value: community_slug
  });
  jQuery(hidden_field).insertAfter(element);
}


function selectCollection(element, collection_slug) {
  var hidden_field = jQuery('<input>').attr({
      id: 'article_dspace_collection_name_',
      name: 'article[dspace_collections_names][]',
      type: 'hidden',
      name: 'article[dspace_collections_names][]',
      value: collection_slug
  });
  jQuery(hidden_field).insertAfter(element);
}

function select_action(field_active) {
}
**/

jQuery(document).ready(function() {
  url_base = window.location.protocol + '//' + window.location.host;
  forms = jQuery('form');
  forms.each( function(f) {
    url_action = forms[f].action;
    if (url_action.indexOf("/cms/new") > -1) {
      forms[f].action = url_action.replace("/cms/new", "/plugin/dspace/new").replace(url_base,'');
    }
  });

  function check_fields(check, table_id) {
    var checkboxes = jQuery("#" + table_id + " tbody tr td input[type='checkbox']")
    for (var i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i].disabled == false) {
        checkboxes[i].checked = check
      }
    }
  }

  function verify_checked(field_id){
    var checkboxes = jQuery("#" + field_id + "_fields_conf tbody tr td input[type='checkbox']")
    var allchecked = true;
    for (var j = 1; j < checkboxes.length; j++) {
      if(!checkboxes[j].checked) {
        allchecked = false;
        break;
      }
    }

    var checkbox = jQuery("#" + field_id + "_active");
    checkbox.attr("checked", allchecked);
  }


  function check_all(field_id) {
    jQuery("#" + field_id + "_active").click(function (){
      check_fields(this.checked, field_id + "_fields_conf")
    });
    verify_checked(field_id);
  }

  check_all("community");
  check_all("collection");

  jQuery("input[type='checkbox']").click(function () {
    var checkbox = jQuery(this).attr("id").split("_");
    verify_checked(checkbox.first());

    if(this.checked == false) {
      jQuery("#" + checkbox.first() + "_" + checkbox.last()).attr("checked", false)
    }

    jQuery(this).next().attr("disabled", !this.checked);
  })

});
