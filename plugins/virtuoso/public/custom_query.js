jQuery(document).ready(function($) {
  $('#copy_custom_query').on('click', function() {
    $.getJSON("/plugin/virtuoso/public/custom_query", {id: $('#select_custom_query').val()}, function(data) {
      $('#article_query').val(data.custom_query.query);
      $('#article_stylesheet').val(data.custom_query.stylesheet);
      tinymce.get('article_template').setContent(data.custom_query.template);
    });
  });
});
