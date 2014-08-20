function makeCommentable() {
  paragraphsTxt="";
  //Add p tag, when opening the editor. For some season it comes without p tag
  foundCommentableParagraph = false;
  jQuery('#article_body_ifr').contents().find('body').children('div.article_comments').each(function( index ) {
    paragraphsTxt+="<p>" + jQuery(this).html() + "</p>";
    foundCommentableParagraph = true;
  });

  //undo the paragraph comment tags
  if(foundCommentableParagraph === true){
    tinyMCE.activeEditor.setContent(paragraphsTxt);
    return;
  }
 
  //Wraps the paragraph using the chosen class
  jQuery('#article_body_ifr').contents().find('body').children('p').each(function( index ) {
    text = jQuery(this).html().trim();
    if(text!="" && text!="<br>"){
      paragraphsTxt+='<p><div class="macro article_comments" data-macro="comment_paragraph_plugin/allow_comment" data-macro-paragraph_id="' + index + '">' + text + '</div></p><br>'
    }
  });
  tinyMCE.activeEditor.setContent(paragraphsTxt); 

  //Workaround necessary to post the body of the article
  tinymce.activeEditor.execCommand('mceInsertContent', false, " ");
}

