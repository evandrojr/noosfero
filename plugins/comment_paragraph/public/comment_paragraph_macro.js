var comment_paragraph_anchor;
var lastParagraph = [];
var lastSelectedArea = [];

function setPlusIfZeroComments($){
  $('.comment-count').each(function(){
    var commentCount = $(this).text().trim();
    if(commentCount=='0')
      $(this).text("+");
  });
}

jQuery(document).ready(function($) {
  //Quit if does not detect a comment for that plugin
  if($('.comment_paragraph').size() < 1)
    return;

  $(document).keyup(function(e) {
    // on press ESC key...
    if (e.which == 27) {
      // closing side comment box
      $("div.side-comment").hide();
    }
  });

  setPlusIfZeroComments($);
  $('.display-comment-form').unbind();
  $('.display-comment-form').click(function(){
    var $button = $(this);
    showBox($button.parents('.post_comment_box'));
    $($button).hide();
    $button.closest('.page-comment-form').find('input').first().focus();
    return false;
  });

  $('#cancel-comment').die();
  $(document.body).on("click", '#cancel-comment', function(){
    $("div.side-comment").hide();
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
      <a id="comment-bubble" style="width:90px;text-decoration: none">\
          <div align="center"  class="triangle-right" >Comentar</div>\
      </a>');


  $('.side-comments-counter').click(function(){
    var paragraphId = $(this).data('paragraph');
    hideAllCommentsExcept(paragraphId);
    hideAllSelectedAreasExcept(paragraphId);
    $('#comment-bubble').hide();
    $('#side_comment_' + paragraphId).toggle();
    $('#side_comment_' + paragraphId).find().toggle();
    //Loads the comments
    var url = $('#link_to_ajax_comments_' + paragraphId).data('url');
    $.ajax({
      dataType: "script",
      url: url
    }).done(function() {
      var button = $('#page-comment-form-' + paragraphId + ' a').get(0);
      button.click();
    });
  });


  $('#comment-bubble').click(function(event){
    $(this).hide();
    $("#comment-bubble").css({top: 0, left: 0, position:'absolute'});
    var url = $("#comment-bubble").data('url');
    var paragraphId = $("#comment-bubble").data("paragraphId");
    hideAllCommentsExcept(paragraphId);
    $('#side_comment_' + paragraphId).show();
    $.ajax({
      dataType: "script",
      url: url
    }).done(function() {
      var button = $('#page-comment-form-' + paragraphId + ' a').get(0);
      button.click();
    });
  });

  function hideAllCommentsExcept(clickedParagraph){
    $(".side-comment").each(function(){
      paragraph = $(this).data('paragraph');
      if(paragraph != clickedParagraph){
        $(this).hide();
        $(this).find().hide();
      }
    });
  }

  function hideAllSelectedAreasExcept(clickedParagraph){
    $(".comment_paragraph").each(function(){
      paragraph = $(this).data('paragraph');
      if(paragraph != clickedParagraph){
        $(this).find(".commented-area").contents().unwrap();
      }
    });
  }

  $("#comment-bubble").hide();
  //Undo previous highlight from the paragraph
  $('.comment_paragraph').mousedown(function(){
    $("#comment-bubble").hide();
    var paragraphId = $(this).data('paragraph');
    $(this).find('.commented-area').replaceWith(function() {
      return $(this).html();
    });
    var rootElement = $(this).get(0);
    if(lastParagraph[paragraphId]){
      rootElement.innerHTML = lastParagraph[paragraphId];
    }
  });

  function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
  }

   //highlight area from the paragraph
  $('.comment_paragraph').mouseup(function(event){
    deselectAll();
    //Don't do anything if there is no selected text
    if(getSelectionText().length == 0)
      return;
    var paragraphId = $(this).data('paragraph');
    var currentMousePos = { x: -1, y: -1 };
    currentMousePos.x = event.pageX;
    currentMousePos.y = event.pageY;
    $("#comment-bubble").css({top: event.pageY-70, left: event.pageX-70, position:'absolute'});
    //Relates a bubble to the mouse up paragraph
    $("#comment-bubble").data("paragraphId", paragraphId)
    //Prepare to open the div
    var url = $('#link_to_ajax_comments_' + paragraphId).data('url');
    $("#comment-bubble").data("url", url)
    $("#comment-bubble").show();
    var rootElement = $(this).get(0);
    //Stores the HTML content of the lastParagraph
    lastParagraph[paragraphId] = rootElement.innerHTML;
    //Maybe it is needed to handle exceptions here
    try{
      var selObj = rangy.getSelection();
      var selected_area = rangy.serializeSelection(selObj, true,rootElement);
      cssApplier.toggleSelection();
    }catch(e){
      //Translate this mesage
      deselectAll();
      rangy.init();
      cssApplier = rangy.createCssClassApplier("commented-area", {normalize: false});
      return;
    }
    //Register the area the has been selected at input.selected_area
    lastSelectedArea[paragraphId] = selected_area;
    form = $('#page-comment-form-' + paragraphId).find('form');
    if (form.find('input.selected_area').length === 0){
      $('<input>').attr({
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

  function deselectAll(){
    $(".commented-area").contents().unwrap();
  }

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
    deselectAll();
    var paragraph_id = $(this).find('input.paragraph_id').val();
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

  function toggleParagraph(paragraph) {
    var div = $('div.comments_list_toggle_paragraph_'+paragraph);
    var visible = div.is(':visible');
    if(!visible)
      $('div.comment-paragraph-loading-' + paragraph).addClass('comment-button-loading');
    div.toggle('fast');
    return visible;
  }

  function loadCompleted(paragraph) {
    $('div.comment-paragraph-loading-'+paragraph).removeClass('comment-button-loading')
    if(comment_paragraph_anchor) {
      $.scrollTo($(comment_paragraph_anchor));
      comment_paragraph_anchor = null;
    }
  }
});