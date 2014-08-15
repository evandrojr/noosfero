function send_ajax(source_url) {
  jQuery(".link-address").autocomplete({
    source : function(request, response){
      jQuery.ajax({
        type: "GET",
        url: source_url,
        data: {query: request.term},
        success: function(result){
          response(result);
        },
        error: function(ajax, stat, errorThrown) {
          console.log('Link not found : ' + errorThrown);
        }
      });
    },

    minLength: 3
  });
}

function new_field_action(){
  send_ajax(jQuery("#page_url").val());

  jQuery(".delete-link-list-row").click(function(){
    jQuery(this).parent().parent().remove();
    return false;
  });

  jQuery(document).scrollTop(jQuery('#dropable-link-list').scrollTop());
}

function remove_custom_field(element) {
  jQuery(element).parent().parent().remove();
  return false;
}

function add_new_field() {

  last_row = jQuery('#person_fields_conf > tbody:last tr:last');

  if ( last_row.find('label').length == 1 ) {

    var row = '<tr>' +
                 '<td>' +
                    '<input id="person_fields_custom_field_1_name" maxlength="20" name="person_fields[custom_field_1][name]" type="text" />' +
                 '</td>' +
                 '<td align="center"> ' +
                    '<input id="person_fields_custom_field_1_active" name="person_fields[custom_field_1][active]" type="hidden" value="false" /> ' +
                    '<input id="person_fields_custom_field_1_active" name="person_fields[custom_field_1][active]" type="checkbox" value="false" /> ' +
                 '</td> ' +
                 '<td align="center"> ' +
                    '<input id="person_fields_custom_field_1_required" name="person_fields[custom_field_1][required]" type="hidden" value="false" /> ' +
                    '<input id="person_fields_custom_field_1_required" name="person_fields[custom_field_1][required]" type="checkbox" value="true" /> ' +
                 '</td> ' +
                 '<td align="center"> ' +
                    '<input id="person_fields_custom_field_1_signup" name="person_fields[custom_field_1][signup]" type="hidden" value="false" /> ' +
                    '<input id="person_fields_custom_field_1_signup" name="person_fields[custom_field_1][signup]" type="checkbox" value="true" /> ' +
                 '</td> ' +
                 '<td> ' +
                    '<a href="#" class="button icon-delete delete-link-list-row" title="Delete" onclick="return remove_custom_field(this);"><span>Delete</span></a> ' +
                 '</td> ' +
               '</tr>';

    jQuery('#person_fields_conf > tbody:last').append(row);

  }
  else {

    var new_field = jQuery('#person_fields_conf > tbody:last tr:last').clone();

    var field = new_field.find('input');
    //var chkboxes = field.filter(':checkbox');

    var re = new RegExp( '\\d', 'g' );
    var id = field.attr('id').match(re);
    var next_id = parseInt(id) + 1;

    jQuery.each( field, function( k, v ) {
      v.id = v.id.replace(id, next_id);
      v.name = v.name.replace(id, next_id);
      if (v.type == 'text') { v.value = '' }
      if (v.type == 'checkbox') { v.value = true; }
      if (v.type == 'hidden') { v.value = false; }

    });

    //field.val('');

    //chkboxes.attr('onclick', chkboxes.attr('onclick').replace(id, next_id));
    //console.log( chkboxes );

    jQuery('#person_fields_conf > tbody').append(new_field);

  }

}

jQuery(document).ready(function(){
  new_field_action();

  //jQuery("#dropable-link-list").sortable({
  //  revert: true,
  //  axis: "y"
  //});
});
