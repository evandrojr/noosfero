function makeCommentable() {
  paragraphsTxt=""

  foundCommentableParagraph = false;
  jQuery('#article_body_ifr').contents().find('body').children('div.article_comments').each(function( index ) {
    paragraphsTxt+="<p>" + jQuery(this).html() + "</p>";
    foundCommentableParagraph = true;
  });

  if(foundCommentableParagraph === true){
    tinyMCE.activeEditor.setContent(paragraphsTxt)
    return;
  }
 
  jQuery('#article_body_ifr').contents().find('body').children('p').each(function( index ) {
      paragraphsTxt+='<p><div class="macro article_comments" data-macro="comment_paragraph_plugin/allow_comment" data-macro-paragraph_id="' + index + '">' + jQuery(this).html() + '</div></p><br>'
  });
  tinyMCE.activeEditor.setContent(paragraphsTxt)
}

