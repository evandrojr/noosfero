var comment_paragraph_anchor;
jQuery(document).ready(function($) {
  var anchor = window.location.hash;
  if(anchor.length==0) return;

  var val = anchor.split('-'); //anchor format = #comment-\d+
  if(val.length!=2 || val[0]!='#comment') return;
  if($('div[data-macro=comment_paragraph_plugin/allow_comment]').length==0) return; //comment_paragraph_plugin/allow_comment div must exists
  var comment_id = val[1];
  if(!/^\d+$/.test(comment_id)) return; //test for integer

  comment_paragraph_anchor = anchor;
  var url = '/plugin/comment_paragraph/public/comment_paragraph/'+comment_id;
  $.getJSON(url, function(data) {
    if(data.paragraph_id!=null) {
      var button = $('div.comment_paragraph_'+ data.paragraph_id + ' a');
      button.click();
      $.scrollTo(button);
    }
  });
});

function toggleParagraph(paragraph) {
  var div = jQuery('div.comments_list_toggle_paragraph_'+paragraph);
  var visible = div.is(':visible');
  if(!visible)
    jQuery('div.comment-paragraph-loading-'+paragraph).addClass('comment-button-loading');

  div.toggle('fast');
  return visible;
}

function loadCompleted(paragraph) {
  jQuery('div.comment-paragraph-loading-'+paragraph).removeClass('comment-button-loading')
  if(comment_paragraph_anchor) {
    jQuery.scrollTo(jQuery(comment_paragraph_anchor));
    comment_paragraph_anchor = null;
  }
}
