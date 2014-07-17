function makeCommentable() {
  paragraphsTxt=""
  jQuery('#article_body_ifr').contents().find('body').children('p').each(function( index ) {
      paragraphsTxt+='<p><div class="macro article_comments" data-macro="comment_paragraph_plugin/allow_comment" data-macro-paragraph_id="' + index + '">' + jQuery(this).html() + '</p></div>'
  });
  tinyMCE.activeEditor.setContent(paragraphsTxt)
}

