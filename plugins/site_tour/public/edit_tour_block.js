function add_new_action() {
  var new_action = jQuery('#edit-tour-block #new-template>li').clone();
  new_action.show();
  jQuery('#droppable-tour-actions').append(new_action);
}

jQuery(document).ready(function(){
  jQuery('#edit-tour-block').on('click', '.delete-tour-action-row', function() {
    jQuery(this).parent().parent().remove();
    return false;
  });

  jQuery("#droppable-tour-actions").sortable({
    revert: true,
    axis: "y"
  });
});
