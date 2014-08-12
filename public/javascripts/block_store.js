jQuery(document).ready(function () {
  jQuery("#block-types-navigation a.previous").hide();
  jQuery('.block-types-group').first().show( 'slide', { direction : 'down' }, 1000, function() {
    jQuery('.block-types-group').first().addClass('active');
    jQuery(".block-types-group.active + .block-types-group").addClass('next');
    jQuery('#block-types-navigation a.previous').click(PreviousSlide);
    jQuery('#block-types-navigation a.next').click(NextSlide);
  });

  firstBlockTypesGroup = jQuery(".block-types-group").first();
  lastBlockTypesGroup = jQuery(".block-types-group").last();
});

function NextSlide() {
  activeBlockTypesGroup = jQuery(".block-types-group.active");
  nextBlockTypesGroup = jQuery(".block-types-group.next").first();

  activeBlockTypesGroup.hide( 'slide', { direction : 'left' }, 1000);
  nextBlockTypesGroup.show( 'slide', { direction : 'right' }, 1000, function() {
    activeBlockTypesGroup.removeClass('active');
    activeBlockTypesGroup.addClass('prev');
    nextBlockTypesGroup.removeClass('next');
    nextBlockTypesGroup.addClass('active');
    jQuery(".block-types-group.active + .block-types-group").addClass('next');
    activeBlockTypesGroup = jQuery(".block-types-group.active");
    jQuery("#block-types-navigation a.previous").show();

    if ( activeBlockTypesGroup.is( lastBlockTypesGroup ) ) {
      jQuery("#block-types-navigation a.next").hide();
    }
  });
}

function PreviousSlide() {
  activeBlockTypesGroup = jQuery(".block-types-group.active");
  previousBlockTypesGroup = jQuery(".block-types-group.prev").last();

  activeBlockTypesGroup.hide( 'slide', { direction : 'right' }, 1000 );
  previousBlockTypesGroup.show( 'slide', { direction : 'left' }, 1000, function() {
    activeBlockTypesGroup.removeClass('active');
    activeBlockTypesGroup.addClass('next');
    previousBlockTypesGroup.removeClass('prev');
    previousBlockTypesGroup.addClass('active');
    activeBlockTypesGroup = jQuery(".block-types-group.active");
    jQuery("#block-types-navigation a.next").show();

    if ( activeBlockTypesGroup.is( firstBlockTypesGroup ) ) {
      jQuery("#block-types-navigation a.previous").hide();
    }
  });
}
