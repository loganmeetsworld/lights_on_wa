$(document).ready(function(){
  console.log('works');
  $("a#test_burst").click(function() {
    $("#visual").html('<h3>Sunburst By Location</h3><p>For information hover over each part of the graph for amount and location. Click through to expand the graph.</p><br>');
      zoomBurst(gon.candidate_sunburst_data, "#visual");
  });
});

var zoomBurst = function(root_data, child) {
  var root = {"name": "All Candidates", "children": root_data}

  var width = 750,
      height = 500;
      radius = Math.min(width, height) / 2;

  var x = d3.scale.linear()
    .range([0, 2 * Math.PI]);

  var y = d3.scale.linear()
    .range([0, radius]);

  var color = d3.scale.category20c();

  /*Tooltip definition */
  var div = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);

  var svg = d3.select(child).append("svg").attr("class", "col-md")
    .attr("width", width)
    .attr("height", height)
    .append("g")
    .attr("transform", "translate(" + width / 2 + "," + (height / 2 ) + ")");

  var partition = d3.layout.partition(root)
    .value(function(d) { return d.count; });

  var arc = d3.svg.arc()
    .startAngle(function(d)  { return Math.max(0, Math.min(2 * Math.PI, x(d.x))); })
    .endAngle(function(d)    { return Math.max(0, Math.min(2 * Math.PI, x(d.x + d.dx))); })
    .innerRadius(function(d) { return Math.max(0, y(d.y)); })
    .outerRadius(function(d) { return Math.max(0, y(d.y + d.dy)); });


  var g = svg.selectAll("g")
    .data(partition.nodes(root))
    .enter().append("g");

  var path = g.append("path")
    .attr("d", arc)
    .style("fill", function(d, i) { return color(i); })
    .on("click", click)
     /*The following two '.on' attributes for tooltip*/
    .on("mouseover", function(d) {
      div.transition()
        .duration(200)
        .style("opacity", .9);
      div.html("Location: " + d.name + "<br/>Number of Contributions: " + d.num_donations + "<br/>Total Amount of Contributions: " + "$" + d.amount.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'))
        .style("left", (d3.event.pageX) + "px")
        .style("top", (d3.event.pageY) + "px");
    })
    .on("mouseout", function(d) {
      div.transition()
        .duration(500)
        .style("opacity", 0);
    });

  function click(d) {
    path.transition()
      .duration(750)
      .attrTween("d", arcTween(d))
  }


  d3.select(self.frameElement).style("height", height + "px");

  function arcTween(d) {
    var xd = d3.interpolate(x.domain(), [d.x, d.x + d.dx]),
      yd = d3.interpolate(y.domain(), [d.y, 1]),
      yr = d3.interpolate(y.range(), [d.y ? 20 : 0, radius]);
    return function(d, i) {
      return i
        ? function(t) { return arc(d); }
        : function(t) { x.domain(xd(t)); y.domain(yd(t)).range(yr(t)); return arc(d); };
    };
  }
}

function sunBurst(jsonObject){
  var width = 750/2,
      height = 500,
      radius = Math.min(width, height) / 2,
      color = d3.scale.category20c();

var svg = d3.select(".sunburst").append("svg").attr("class", "center-sun")
  .attr("width", width)
  .attr("height", height)
  .append("g")
  .attr("transform", "translate(" + width + "," + height + ")");

var partition = d3.layout.partition()
  .sort(null)
  .size([2 * Math.PI, radius * radius])
  .value(function(d) { return 1; });

var arc = d3.svg.arc()
  .startAngle(function(d) { return d.x; })
  .endAngle(function(d) { return d.x + d.dx; })
  .innerRadius(function(d) { return Math.sqrt(d.y); })
  .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });


  var path = svg.datum(jsonObject).selectAll("path")
    .data(partition.nodes)
    .enter().append("path")
    .attr("display", function(d) { return d.depth ? null : "none"; }) // hide inner ring
    .attr("d", arc)
    .style("stroke", "#fff")
    .style("fill", function(d) { return color((d.children ? d : d.parent).name); })
    .style("fill-rule", "evenodd")
    .each(stash);

  d3.selectAll("input").on("change", function change() {
    var value = this.value === "count"
      ? function() { return 1; }
      : function(d) { return d.size; };

    path
      .data(partition.value(value).nodes)
      .transition()
      .duration(1500)
      .attrTween("d", arcTween);
  });


function stash(d) {
  d.x0 = d.x;
  d.dx0 = d.dx;
}

function arcTween(a) {
  var i = d3.interpolate({x: a.x0, dx: a.dx0}, a);
  return function(t) {
    var b = i(t);
    a.x0 = b.x;
    a.dx0 = b.dx;
    return arc(b);
  };
}

d3.select(self.frameElement).style("height", height + "px");

};