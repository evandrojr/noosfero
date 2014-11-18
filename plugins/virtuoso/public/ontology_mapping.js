jQuery(document).ready(function($) {

  $('#new-ontology-button').on('click', function() {
    $('#ontology-table').append($('#ontology-item-template tr').clone());
  });

  $('#ontology-table').on('click', '.remove-ontology-button', function() {
    $(this).parents('tr').remove();
  });

});
