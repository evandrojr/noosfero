jQuery(document).ready(function () {

  // navigation - click action
  jQuery('#block-types-navigation a#previous').click(PreviousSlide);
  jQuery('#block-types-navigation a#next').click(NextSlide);

  // set first block types group active
  jQuery('.block-types-group').first().addClass('active');
  jQuery(".block-types-group.active + .block-types-group").addClass('next');

  firstBlockTypesGroup = jQuery(".block-types-group").first();
  lastBlockTypesGroup = jQuery(".block-types-group").last();
  jQuery("#block-types-navigation a#previous").hide();
});

function NextSlide() {
    // get active block-types-group
    activeBlockTypesGroup = jQuery(".block-types-group.active");

    // get next block-types-group
    nextBlockTypesGroup = jQuery(".block-types-group.next").first();

    // switch active group
    activeBlockTypesGroup.removeClass('active');
    activeBlockTypesGroup.addClass('prev');
    activeBlockTypesGroup.css({"display":"none"});
    nextBlockTypesGroup.removeClass('next');
    nextBlockTypesGroup.addClass('active');
    nextBlockTypesGroup.css({"display": "block"});

    jQuery(".block-types-group.active + .block-types-group").addClass('next');

    activeBlockTypesGroup = jQuery(".block-types-group.active");

    jQuery("#block-types-navigation a#previous").show();

    if ( activeBlockTypesGroup.is( lastBlockTypesGroup ) ) {
      jQuery("#block-types-navigation a#next").hide();
    }
}

function PreviousSlide() {
    // get active block-types-group
    activeBlockTypesGroup = jQuery(".block-types-group.active");

    // get previous block-types-group
    previousBlockTypesGroup = jQuery(".block-types-group.prev").last();

    // switch active group
    activeBlockTypesGroup.removeClass('active');
    activeBlockTypesGroup.addClass('next');
    activeBlockTypesGroup.css({"display":"none"});
    previousBlockTypesGroup.removeClass('prev');
    previousBlockTypesGroup.addClass('active');
    previousBlockTypesGroup.css({"display": "block"});

    activeBlockTypesGroup = jQuery(".block-types-group.active");

    jQuery("#block-types-navigation a#next").show();

    if ( activeBlockTypesGroup.is( firstBlockTypesGroup ) ) {
      jQuery("#block-types-navigation a#previous").hide();
    }
}

