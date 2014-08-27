var comment_paragraph_anchor;
var lastParagraph = [];
var lastSelectedArea = [];
var sideCommentForm=null;
var firstTimeOpenParagraph = Array();
var commentParagraphIds = Array();

function getIdCommentParagraph(paragraphId){
  var idx = paragraphId.lastIndexOf('_');
  return paragraphId.substring(idx+1, paragraphId.length);
}

function teleportToBody(element){
    var $ = jQuery;
    element.detach();
    $('body').append(element);
}

function moveCommentsToTheSide(paragraphId, mouseX, mouseY){
  var $ = jQuery;
  //var element = sideCommentForm;
  //element.detach();
  //if ( $('body #side_comment_form').size === 0){
//    $('body').append(element);
//  }
  //element.css({top: 0, border-right: 20, position:'absolute'});
}

//function buildSideCommentBlock(){
//  var $ = jQuery;
//  $("body").append('\
//    <div align="left" id="side_comments_box" class="side-comments-box">\n\
//      [side comments collumn]<BR>\n\
//      [side comments collumn]<BR>\n\
//    </div>\n\
//  ');
//  //Detects if there is any comment paragraph
//  
//  //  var button = jQuery('#page-comment-form-' + paragraphId +  ' a')[0];
//}

function buildSideCommentBox(id, commentCount ){
  var $ = jQuery;
  //Search to top of the respective paragraph
  var top = $('#comment_paragraph_' + id).offset().top;
  var right = $('#comment_paragraph_' + id).offset().left + $('#comment_paragraph_' + id).width() + 20;
  
  var boxComments="\n\
    <div class='side-comments-counter'\n\
        id='side_comment_counter_" + id + "' style='top: " + top + "px; left: " + (right - 20) + "px;'  >+</div> \n\
    </div>";
    //<div class='side-comments-box'  id='side_comment_box_" + id + "' style='top: " + top + "px; left: " + right + "px;' ></div>"; 
  return boxComments;
}

function putSideComments(){
  var $ = jQuery;

  $(".comment-count").each(function(index){
    //Include all comments except the last
    var idElement = $(this).attr('id');
    if(idElement != undefined ){
      var n = idElement.lastIndexOf('-');
      var id_number =  idElement.substr(n + 1, idElement.length - n +1);
      firstTimeOpenParagraph[id_number] = true;
      commentParagraphIds.push(id_number);
      var commentCount = $(this).text().trim();
      commentCount = parseInt(commentCount);
      var box = buildSideCommentBox(id_number, commentCount);
      $('body').append(box);
      if(commentCount > 0){
        $('#side_comment_counter_' + id_number).text(commentCount);
//        $('#side_comment_counter_' + id_number).show();
      }
      $('#side_comment_counter_' + id_number).show();
    }
  });      
}



jQuery(document).ready(function($) {
  //Hides old style ballons
  $("img[alt|=Comments]").hide();
  //Hides old style counter
  $(".comment-count").hide();
  
  rangy.init();
  cssApplier = rangy.createCssClassApplier("commented-area", {normalize: false});
  
  //Add marked text bubble
  $("body").append('\
      <a href="#" id="comment-bubble" style="width:120px;text-decoration: none">\
          <div align="center"  class="triangle-right" >Comentar<br>+</div>\
      </a>');
  //buildSideCommentBlock();
  //
  //Creates a side bubble for each paragraph with the amount of comments
  putSideComments();

  $('.comment_paragraph').mouseover(function(){
    var paragraphId = getIdCommentParagraph($(this)[0].id);
    $('#side_comment_counter_' + paragraphId).show();
  });
  
  $('.comment_paragraph').mouseleave(function(){
    var paragraphId = getIdCommentParagraph($(this)[0].id);
//    if($('#side_comment_counter_' + paragraphId).text() == '+'){
//      $('#side_comment_counter_' + paragraphId).hide();
//    }
  });
  
  $('.side-comments-counter').click(function(){
    hideAllComments();
    var paragraphId = getIdCommentParagraph($(this).attr('id'));
    $('#side_comment_box_' + paragraphId).toggle();  
    //Loads the comments
    var url = $('#link_to_ajax_comments_' + paragraphId).data('url'); 
    $('.comments_list_toggle_paragraph_' + paragraphId).show();
    if(firstTimeOpenParagraph[paragraphId]===true ){
      firstTimeOpenParagraph[paragraphId]=false;
      $.ajax({
        dataType: "script",
        url: url
      }).done(function() {
        var button = $('#page-comment-form-' + paragraphId + ' a').get(0);
        button.click();
        //teleportToBody($('.comments_list_toggle_paragraph_' + paragraphId));
        var top = $('#comment_paragraph_' + paragraphId).offset().top;
        var right = $('#comment_paragraph_' + paragraphId).offset().left + $('#comment_paragraph_' + paragraphId).width();
        top += -120;
        right+= -500;
        $('.comments_list_toggle_paragraph_' + paragraphId).css('position','absolute');
        $('.comments_list_toggle_paragraph_' + paragraphId).css('top',top);
        $('.comments_list_toggle_paragraph_' + paragraphId).css('left',right);
        $('.comments_list_toggle_paragraph_' + paragraphId).css('background','#FFFFFF');
        $('label[for|=comment_title]').hide();
        $('label[for|=comment_body]').css({top: -30, left: +20, position:'relative'});
        $('.comment_form p').hide();
        $('.comments_list_toggle_paragraph_' + paragraphId).width('250px');
      });
    }
  });

   
  function hideAllComments(){
    for (index = 0; index < commentParagraphIds.length; ++index) {
      $('.comments_list_toggle_paragraph_' + commentParagraphIds[index]).hide();
    }
  } 

  
  $("#comment-bubble").hide();
  //Undo previous highlight from the paragraph
  $('.comment_paragraph').mousedown(function(){
    var paragraphId = getIdCommentParagraph($(this)[0].id);
    $(this).find('.commented-area').replaceWith(function() {
      return $(this).html();
    });
    var rootElement = $(this).get(0);
    if(lastParagraph[paragraphId]){
      rootElement.innerHTML = lastParagraph[paragraphId];
    }
  });
  
  
//  $('#comment-bubble').mouseleave(function(){
//    this.hide();
//    $("#comment-bubble").css({top: 0, left: 0, position:'absolute'});
//  });
 
   //highlight area from the paragraph
  $('.comment_paragraph').mouseup(function(event){
    var paragraphId = getIdCommentParagraph($(this)[0].id);
    var currentMousePos = { x: -1, y: -1 };
    currentMousePos.x = event.pageX;
    currentMousePos.y = event.pageY;
    $("#comment-bubble").css({top: event.pageY-100, left: event.pageX-70, position:'absolute'});      
    $("#comment-bubble").data("paragraphId", paragraphId)
    var url = $('#link_to_ajax_comments_' + paragraphId).data('url');      
    $("#comment-bubble").data("url", url)
    $("#comment-bubble").show();
    var rootElement = $(this).get(0);
    lastParagraph[paragraphId] = rootElement.innerHTML;
    var selObj = rangy.getSelection();
    var selected_area = rangy.serializeSelection(selObj, true,rootElement); 
    cssApplier.toggleSelection();
    lastSelectedArea[paragraphId] = selected_area;   
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
  
 
//  $('#comment-bubble').click(function(event){
//    this.hide();
//    hideAllComments();
//    $("#comment-bubble").css({top: 0, left: 0, position:'absolute'});
//    var url = $("#comment-bubble").data('url');
//    var paragraphId = $("#comment-bubble").data("paragraphId");
//
//    $('.comments_list_toggle_paragraph_' + paragraphId).show();
//    $.ajax({
//      dataType: "script",
//      url: url
//    }).done(function() {
//      var button = $('#page-comment-form-' + paragraphId + ' a').get(0)
//      button.click();
//      window.location="#page-comment-form-" + paragraphId;
////      //Move comments
////      sideCommentForm = $('#side_comment_form');
////      sideCommentForm.hide();
////      sideCommentForm = $('.comment_form').first();
////      sideCommentForm.attr("id",'side_comment_form');
////      moveCommentsToTheSide(paragraphId, event.pageX, event.pageY);
//    });
//  });
  

  function processAnchor(){
    var anchor = window.location.hash;
    if(anchor.length==0) return;

    var val = anchor.split('-'); //anchor format = #comment-\d+
    if(val.length!=2 || val[0]!='#comment') return;
    if($('div[data-macro=comment_paragraph_plugin\\/allow_comment]').length==0) return; //comment_paragraph_plugin/allow_comment div must exists
    var comment_id = val[1];
    if(!/^\d+$/.test(comment_id)) return; //test for integer

    comment_paragraph_anchor = anchor;
    var url = '/plugin/comment_paragraph/public/comment_paragraph/'+comment_id;
    $.ajax({
      dataType: "script",
      url: url
    }).done(function() {
      var button = $('#page-comment-form-' + comment_id + ' a').get(0)
      button.click();
////        window.location="#page-comment-form-" + paragraphId;
//      //Move comments
//      sideCommentForm = $('#side_comment_form');
//      sideCommentForm.hide();
//      sideCommentForm = $('.comment_form').first();
//      sideCommentForm.attr("id",'side_comment_form');
//      moveCommentsToTheSide(paragraphId, event.pageX, event.pageY);
    });
  }
 
  processAnchor();
 
  $(document).on('mouseover', 'li.article-comment', function(){
    var selected_area = $(this).find('input.paragraph_comment_area').val();
    var paragraph_id =  $(this).find('input.paragraph_id').val();
    var rootElement = $('#comment_paragraph_'+ paragraph_id).get(0);
   
    if(lastParagraph[paragraph_id] == null || lastParagraph[paragraph_id] == 'undefined'){
      lastParagraph[paragraph_id] = rootElement.innerHTML;
    }
    else {
      rootElement.innerHTML = lastParagraph[paragraph_id] ;
    }
    if(selected_area != ""){
      rangy.deserializeSelection(selected_area, rootElement);
      cssApplier.toggleSelection();
    }
  });
 
  $(document).on('mouseout', 'li.article-comment', function(){
    var paragraph_id =  $(this).find('input.paragraph_id').val();
    var rootElement = $('#comment_paragraph_'+ paragraph_id).get(0);
  
    if(lastSelectedArea[paragraph_id] != null && lastSelectedArea[paragraph_id] != 'undefined' ){
      rootElement = $('#comment_paragraph_'+ paragraph_id).get(0);
      rootElement.innerHTML = lastParagraph[paragraph_id];
      rangy.deserializeSelection(lastSelectedArea[paragraph_id], rootElement);
      cssApplier.toggleSelection();
    } else {
      cssApplier.toggleSelection();
      var sel = rangy.getSelection();
      sel.removeAllRanges();
    }
  });
});

function toggleParagraph(paragraph) {
  var div = jQuery('div.comments_list_toggle_paragraph_'+paragraph);
  var visible = div.is(':visible');
  if(!visible)
    jQuery('div.comment-paragraph-loading-' + paragraph).addClass('comment-button-loading');
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
