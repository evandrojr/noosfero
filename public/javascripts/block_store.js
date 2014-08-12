jQuery(document).ready(function () {
  jQuery('#block-types-navigation a.previous').click(PreviousSlide);
  jQuery('#block-types-navigation a.next').click(NextSlide);
  jQuery('.block-types-group').first().addClass('active');
  jQuery(".block-types-group.active + .block-types-group").addClass('next');
  firstBlockTypesGroup = jQuery(".block-types-group").first();
  lastBlockTypesGroup = jQuery(".block-types-group").last();
  jQuery('.block-types-group').first().show( 'slide', { direction : 'down' }, 1000 );
  jQuery("#block-types-navigation a.previous").hide();
});

function NextSlide() {
    activeBlockTypesGroup = jQuery(".block-types-group.active");
    nextBlockTypesGroup = jQuery(".block-types-group.next").first();
    activeBlockTypesGroup.removeClass('active');
    activeBlockTypesGroup.addClass('prev');
    activeBlockTypesGroup.hide( 'slide', { direction : 'left' }, 1000 );
    nextBlockTypesGroup.removeClass('next');
    nextBlockTypesGroup.addClass('active');
    jQuery(".block-types-group.active + .block-types-group").addClass('next');
    nextBlockTypesGroup.show( 'slide', { direction : 'right' }, 1000 );
    activeBlockTypesGroup = jQuery(".block-types-group.active");
    jQuery("#block-types-navigation a.previous").show();

    if ( activeBlockTypesGroup.is( lastBlockTypesGroup ) ) {
      jQuery("#block-types-navigation a.next").hide();
    }
}

function PreviousSlide() {
    activeBlockTypesGroup = jQuery(".block-types-group.active");
    previousBlockTypesGroup = jQuery(".block-types-group.prev").last();
    activeBlockTypesGroup.removeClass('active');
    activeBlockTypesGroup.addClass('next');
    activeBlockTypesGroup.hide( 'slide', { direction : 'right' }, 1000 );
    previousBlockTypesGroup.removeClass('prev');
    previousBlockTypesGroup.addClass('active');
    previousBlockTypesGroup.show( 'slide', { direction : 'left' }, 1000 );
    activeBlockTypesGroup = jQuery(".block-types-group.active");
    jQuery("#block-types-navigation a.next").show();

    if ( activeBlockTypesGroup.is( firstBlockTypesGroup ) ) {
      jQuery("#block-types-navigation a.previous").hide();
    }
}
