function cloneDraggableBlock(el, blockIcon) {
  el.addClass('ui-draggable-dragging');
  return blockIcon;
}

function startDragBlock() {
  $('#box-organizer').addClass('shadow');
}

function stopDragBlock() {
  $('#box-organizer').removeClass('shadow');
  $('.ui-draggable-dragging').removeClass('ui-draggable-dragging');
}

jQuery(document).ready(function($) {
  var store = $('#block-store #block-types').slick({
    infinite: true,
    dots: true,
    draggable: false,
    respondTo: 'slider',
    slidesToShow: 7,
    slidesToScroll: 4,
    responsive: [
      {
        breakpoint: 2048,
        settings: {
          slidesToShow: 10,
          slidesToScroll: 4,
        }
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 8,
          slidesToScroll: 4,
        }
      }
    ]
  });
});
