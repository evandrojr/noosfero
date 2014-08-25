function load_proposals_graph(data, comments_data, proposals_label, comments_label) {

jQuery(document).ready(function($) {
  container = $('#proposals-time')[0];
  console.log(comments_data);

  var
    d1 = [], d2 = [],
    start = new Date("2009/01/01 01:00").getTime(),
    options,
    graph,
    i, x, o;

  data = jQuery.parseJSON(data);
  for (var key in data) {
     d1.push([new Date(key).getTime(), data[key]]);
  }

  comments_data = jQuery.parseJSON(comments_data);
  for (var key in comments_data) {
     d2.push([new Date(key).getTime(), comments_data[key]]);
  }

  options = {
    xaxis : {
      mode : 'time',
      labelsAngle : 45,
      noTicks: 7
    },
    selection : {
      mode : 'x'
    },
    HtmlText : false,
  };

  // Draw graph with default options, overwriting with passed options
  function drawGraph (opts) {
    // Clone the options, so the 'options' variable always keeps intact.
    o = Flotr._.extend(Flotr._.clone(options), opts || {});
    // Return a new graph.
    return Flotr.draw(
      container,
      [
        {data: d1, label: proposals_label, lines : { show : true }, points : { show : true } }, 
        {data: d2, label: comments_label, lines : { show : true }, points : { show : true }}
      ],
      o
    );
  }

  graph = drawGraph();

  Flotr.EventAdapter.observe(container, 'flotr:select', function(area){
    // Draw selected area
    graph = drawGraph({
      xaxis : { min : area.x1, max : area.x2, mode : 'time', labelsAngle : 45 },
      yaxis : { min : area.y1, max : area.y2 }
    });
  });

  // When graph is clicked, draw the graph with default area.
  Flotr.EventAdapter.observe(container, 'flotr:click', function () { graph = drawGraph(); });
});
}
