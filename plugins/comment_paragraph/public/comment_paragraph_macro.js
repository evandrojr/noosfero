var comment_paragraph_anchor;
jQuery(document).ready(function($) {
  rangy.init();
  cssApplier = rangy.createCssClassApplier("commented-area", {normalize: false});
  //Undo previous highlight from the paragraph
  $('.comment_paragraph').mousedown(function(){
    $(this).find('.commented-area').replaceWith(function() {
      return $(this).html();
    });
  }); 
  
   //highlight area from the paragraph
  $('.comment_paragraph').mouseup(function(){
    rootElement = $(this).get(0);
    console.log(rootElement)
    cssApplier.toggleSelection();
    var selObj = rangy.getSelection();
    var selected_area = rangy.serializeSelection(selObj, true,rootElement);  
    form = jQuery(this).parent().find('form');
    if (form.find('input.selected_area').length === 0){
      jQuery('<input>').attr({
        class: 'selected_area',
        type: 'hidden',
        name: 'comment[comment_paragraph_selected_area]',
        value: selected_area
      }).appendTo(form)
    }else{
      form.find('input.selected_area').val(selected_area)
    }    
    rootElement.focus();
  }); 


// em <li id="comment-31" class="article-comment"> colocar um data-paragraph e data-selected-area
 //highlight area from the paragraph
  $('.article-comment').mouseover(function(){
    rootElement = $('#comment_paragraph_' + this).get(0);
    var selObj = rangy.getSelection();
    var se = $('#result').val();
    rangy.deserializeSelection(se, rootElement);
    cssApplier.toggleSelection();
  });

  function processSomething(){
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
  }
  
  processSomething();
  
});

function selectAreaForComment(paragraph){
//    console.log(this)
//    alert("Paragrafo " + paragraph)
//    cssApplier.toggleSelection();
//    saveSelection();
//    var selObj = rangy.getSelection();
//    var se = rangy.serializeSelection(selObj, true,rootElement);  
}


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



//Return a string with the beggining and the end of the selection of a text area separated by colon
function getSelectionBounderies(textareaId){
    
//    var textarea = document.getElementById(textareaId);
//    if ('selectionStart' in textarea) {
//            // check whether some text is selected in the textarea
//        if (textarea.selectionStart != textarea.selectionEnd) {
//            alert(textarea.selectionStart + ":" + textarea.selectionEnd)
//            return textarea.selectionStart + ":" + textarea.selectionEnd;
//        }
//    }
    
    return false
}
