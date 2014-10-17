String.prototype.startsWith = function(needle){
  return(this.indexOf(needle) == 0);
};

function makeAllCommentable() {
  var paragraphsTxt="";
  var selectedTextCount=0;
  var notSelectedTextCount=0;
  var text;
  
  //Search for text that is not selected in the middle of selected text, in this case unselect everything
  jQuery('#article_body_ifr').contents().find('body').children().each(function( index ) {
    //Check if there are other texts not selected  
    var element=jQuery(this).prop('outerHTML'); 
    if(element.startsWith('<div')){
      selectedTextCount++;
    }else{
      if(! element.startsWith('<p><br></p>') && ! element.startsWith('<p>&nbsp;</p>') ){
        notSelectedTextCount++;
      }
    }
  });
  
  if(selectedTextCount > 0 && notSelectedTextCount>0){
    jQuery('#article_body_ifr').contents().find('body').children('.paragraph_comment').contents().unwrap();
    //Workaround necessary to post the body of the article
    tinymce.activeEditor.execCommand('mceInsertContent', false, " ");    
    return;
  }

  //Add p tag, when opening the editor. For some season it appear at the end without p tag
  foundCommentableParagraph = false;
  jQuery('#article_body_ifr').contents().find('body').children('div.article_comments').each(function( index ) {
    if(jQuery(this).html()!="" && jQuery(this).html()!=" " && jQuery(this).html()!="<br>"){
      paragraphsTxt+="<p>" + jQuery(this).html() + "</p>";
    }
    foundCommentableParagraph = true;
  });

  //undo the paragraph comment tags
  if(foundCommentableParagraph === true){
    tinyMCE.activeEditor.setContent(paragraphsTxt);
    return;
  }

  //Wraps the paragraph using the chosen class
  jQuery('#article_body_ifr').contents().find('body').children('p,table,img').each(function( index ) {
    text=jQuery(this).prop('outerHTML'); 
    if(text!="" && text!=" " && text!="<br>"){
      paragraphsTxt+='<div class="macro article_comments paragraph_comment" data-macro="comment_paragraph_plugin/allow_comment" data-macro-paragraph_id="' + index + '">' + text + '</div><br>'
    }
  });
  tinyMCE.activeEditor.setContent(paragraphsTxt); 

  //Workaround necessary to post the body of the article
  tinymce.activeEditor.execCommand('mceInsertContent', false, " ");
}
