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

jQuery(document).ready(function($) {
  $('.display-comment-form').unbind();
  $('.display-comment-form').click(function(){
    var $button = $(this);
    showBox($button.parents('.post_comment_box'));
    $($button).hide();
    $button.closest('.page-comment-form').find('input').first().focus();
    return false;
  });

  $('#cancel-comment').die();
  $('#cancel-comment').live("click", function(){
    var $button = $(this);
    showBox($button.parents('.post_comment_box'));
    show_display_comment_button();
    var page_comment_form = $button.parents('.page-comment-form');
    page_comment_form.find('.errorExplanation').remove();
    $(this).closest("textarea[name^='comment'").text("");
    $(this).closest("div[class^='side-comment']").hide(); 
    return false;
  });

  function showBox(div){
    if(div.hasClass('closed')) {
      div.removeClass('closed');
      div.addClass('opened');
    } 
  }  
  
  
  //Hides old style ballons
  $("img[alt|=Comments]").hide();
  rangy.init();
  cssApplier = rangy.createCssClassApplier("commented-area", {normalize: false});
  //Add marked text bubble
  $("body").append('\
      <a id="comment-bubble" style="width:120px;text-decoration: none">\
          <div align="center"  class="triangle-right" >Comentar<br>+</div>\
      </a>');

  //Creates a side bubble for each paragraph with the amount of comments
  //putSideComments();

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
    var paragraphId = $(this).data('paragraph')
    $('#side_comment_' + paragraphId).show();
    $('#comments_list_toggle_paragraph_' + paragraphId).show();
    console.log(paragraphId);
    //Loads the comments
    var url = $('#link_to_ajax_comments_' + paragraphId).data('url'); 
    firstTimeOpenParagraph[paragraphId]=false;
    $.ajax({
      dataType: "script",
      url: url
    }).done(function() {
      var button = $('#page-comment-form-' + paragraphId + ' a').get(0);
      button.click();
      alignSideComments(paragraphId);
    });
  });
  
  
  $('#comment-bubble').click(function(event){
    this.hide();
    hideAllComments();
    $("#comment-bubble").css({top: 0, left: 0, position:'absolute'});
    var url = $("#comment-bubble").data('url');
    var paragraphId = $("#comment-bubble").data("paragraphId");
    $('#side_comment_' + paragraphId).show();
    $.ajax({
      dataType: "script",
      url: url
    }).done(function() {
      var button = $('#page-comment-form-' + paragraphId + ' a').get(0);
      button.click();
      alignSideComments(paragraphId);  
    });
  });  
   
  function alignSideComments(paragraphId){
//    var top = $('#comment_paragraph_' + paragraphId).offset().top;
//    var right = $('#comment_paragraph_' + paragraphId).offset().left + $('#comment_paragraph_' + paragraphId).width();
//    top += -120;
//    right+= -500;
//    $('.comments_list_toggle_paragraph_' + paragraphId).css('position','absolute');
//    $('.comments_list_toggle_paragraph_' + paragraphId).css('display','inline');
//    $('.comments_list_toggle_paragraph_' + paragraphId).css('top',top);
//    $('.comments_list_toggle_paragraph_' + paragraphId).css('left',right);
    $('.comments_list_toggle_paragraph_' + paragraphId).css('background','#FFFFFF');
    $('label[for|=comment_title]').hide();
    $('label[for|=comment_body]').css({top: -30, left: +20, position:'relative'});
    $('.comment_form p').hide();
    $('.comments_list_toggle_paragraph_' + paragraphId).width('250px');
    $('.required-field').removeClass("required-field");
  } 
   
  function hideAllComments(){
    $(".side-comment").hide();
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
  
  $('.article-body').mousedown(function(event){
    $( ".commented-area" ).contents().unwrap();
  });

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
      //alignSideComments(paragraphId); 
    });
  }
 
  processAnchor();
 
  $(document).on('mouseover', 'li.article-comment', function(){
    console.log("mouseover");
    
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
    console.log("mouseout");
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
  
//  $('.icon-cancel').unbind('click').click(function(e){
//    e.preventDefault();
//    $(this).closest("textarea[name^='comment'").text("");
//    $(this).closest("div[class^='comments_list_toggle_paragraph_']").hide(); 
//  });
}); // End of jQuery(document).ready(function($)

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