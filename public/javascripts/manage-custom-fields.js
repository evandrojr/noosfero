function update_active(name_active, name_required, name_signup) {
  var required = jQuery("input[name='" + name_required + "']")[0]
  var signup = jQuery("input[name='" + name_signup + "']")[0]
  var active = jQuery("input[name='" + name_active + "']")[0]

  if(required.checked || signup.checked)
    active.checked = true
}

function active_action(obj_active, name_required, name_signup) {
  var required = jQuery("input[name='" + name_required + "']")[0]
  var signup = jQuery("input[name='" + name_signup + "']")[0]

  required.disabled = signup.disabled = !obj_active.checked
}

function required_action(name_active, name_required, name_signup) {
  var obj_required = jQuery("input[name='" + name_required + "']")[0]

  if(obj_required.checked) {
    jQuery("input[name='" + name_signup + "']")[0].checked = true
  }

  update_active(name_active, name_required, name_signup)
}

function signup_action(name_active, name_required, name_signup) {
  var obj_signup = jQuery("input[name='" + name_signup + "']")[0]

  if(!obj_signup.checked) {
    jQuery("input[name='" + name_required + "']")[0].checked = false
  }

  update_active(name_active, name_required, name_signup)
}

function remove_custom_field(element) {
  jQuery(element).parent().parent().remove();
  if ( (jQuery('#custom-fields-container tr').length) == 1 ) {
    jQuery('#custom-fields-container table').hide();
  }
  return false;
}

function add_new_field() {
  var next_custom_field_id;
  var re = /\d+/g;

  if ( (jQuery('#custom-fields-container tr').length) == 1 ) {
    next_custom_field_id = 1;
  }
  else {
    next_custom_field_id = parseInt(re.exec( jQuery('#custom-fields-container input').last().attr('id') )[0]) + 1;
  }

  jQuery('#custom-fields-container table').show();

  new_custom_field = '' +
                    '<tr>' +
                      '<td>' +
                        '<input id="profile_data_custom_fields_custom_field_' + next_custom_field_id + '_label" name="profile_data[custom_fields][custom_field_' + next_custom_field_id + '][label]" style="display:block" type="text" value="">' +
                      '</td>' +
                      '<td align="center">' +
                        '<input id="profile_data_custom_fields_custom_field_' + next_custom_field_id + '_signup" name="profile_data[custom_fields][custom_field_' + next_custom_field_id + '][signup]" onclick="signup_action("profile_data[custom_fields][custom_field_' + next_custom_field_id + '][active]","profile_data[custom_fields][custom_field_' + next_custom_field_id + '][required]", "profile_data[custom_fields][custom_field_' + next_custom_field_id + '][signup]")" type="checkbox">' +
                      '</td>' +
                      '<td align="center">' +
                        '<a href="#" class="button icon-delete link-this-page" onclick="return remove_custom_field(this);" title="Delete"><span>Delete</span></a>' +
                      '</td>' +
                    '</tr>'

  jQuery('#custom-fields-container tbody').append(new_custom_field);
}

/**
jQuery(document).ready(function(){
  function check_fields(check, table_id, start) {
    var checkboxes = jQuery("#" + table_id + " tbody tr td input[type='checkbox']")
    for (var i = start; i < checkboxes.length; i+=3) {
      checkboxes[i].checked = check
    }
  }

  function verify_checked(fields_id){
    var checkboxes = jQuery("#" + fields_id + "_fields_conf tbody tr td input[type='checkbox']")
    for (var i = 2; i >= 0; i--) {
      var allchecked = true
      for (var j = i+3; j < checkboxes.length; j+=3) {
        if(!checkboxes[j].checked) {
          allchecked = false
          break
        }
      }

      var checkbox = jQuery(checkboxes[i+3]).attr("id").split("_")
      jQuery("#" + checkbox.first() + "_" + checkbox.last()).attr("checked", allchecked)
    }
  }

  function check_all(fields_id) {
    jQuery("#" + fields_id + "_active").click(function (){check_fields(this.checked, fields_id + "_fields_conf", 0)})
    jQuery("#" + fields_id + "_required").click(function (){check_fields(this.checked, fields_id + "_fields_conf", 1)})
    jQuery("#" + fields_id +"_signup").click(function (){check_fields(this.checked, fields_id + "_fields_conf", 2)})
    verify_checked(fields_id)
  }

  //check_all("person")
  //check_all("enterprise")
  //check_all("community")

  jQuery("input[type='checkbox']").click(function (){
    var checkbox = jQuery(this).attr("id").split("_")
    verify_checked(checkbox.first())

    if(this.checked == false) {
      jQuery("#" + checkbox.first() + "_" + checkbox.last()).attr("checked", false)
    }
  })
})
**/
