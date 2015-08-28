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
                        '<input id="profile_data_custom_fields_custom_field_' + next_custom_field_id + '_title" name="profile_data[custom_fields][custom_field_' + next_custom_field_id + '][title]" style="display:block" type="text" value="" maxlength="30" size="30">' +
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

function show_fields_for_template(element) {
  jQuery('div#signup-form-custom-fields div.formfieldline').remove();
  var selected_template = jQuery(element).attr('value');
  jQuery.ajax({
    type: "GET",
    url: "/account/custom_fields_for_template",
    dataType: 'json',
    data: { template_id : selected_template },
    success: function(data) {
      if (data.ok)  {
        data.custom_fields.each(function(field) {
          html = '<div class="formfieldline">' +
                       '<label class="formlabel" for="profile_data_custom_fields_{#CUSTOM_FIELD_ID#}">{#CUSTOM_FIELD_NAME#}</label>' +
                       '<input type="hidden" name="profile_data[custom_fields][{#CUSTOM_FIELD_ID#}][title]" id="profile_data_custom_fields_{#CUSTOM_FIELD_ID#}_title" value="{#CUSTOM_FIELD_NAME#}" />' +
                       '<div class="formfield type-text">' +
                          '<input type="text" name="profile_data[custom_fields][{#CUSTOM_FIELD_ID#}][value]" id="profile_data_custom_fields_{#CUSTOM_FIELD_ID#}_value" />' +
                       '</div>' +
                     '</div>';

          html = html.replace( /{#CUSTOM_FIELD_ID#}/g, field.name );
          html = html.replace( /{#CUSTOM_FIELD_NAME#}/g, field.title );
          jQuery('div#signup-form-custom-fields').append(html);
        });
      };
    }
  });
}

jQuery(document).ready(function($) {
  show_fields_for_template($('#template-options input[type=radio]:checked'));
});
