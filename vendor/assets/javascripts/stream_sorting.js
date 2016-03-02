var st; //For debuggin only
$(document).ready(function() {
  if ($('h2').text() === "Start Exploring Campaign Finance in WA State") {
    var data = gon.candidates, html = $.trim($("#template").html()), template = Mustache.compile(html);
  } else if ($('h2').text().includes("Race")) {
    var data = gon.contributions, html = $.trim($("#template").html()), template = Mustache.compile(html);
  } else {
    console.log("no data needed for table");
  };
  
  var view = function(record, index){
    
    return template({record: record, index: index});
  };
  var $summary = $('#summary');
  var $found = $('#found');
  var $record_count = $('#record_count');

  $('#found').hide();

  var callbacks = {
    pagination: function(summary){
      if ($.trim($('#st_search').val()).length > 0){
        $found.text('Found : '+ summary.total).show();
      }else{
        $found.hide();
      }
      $summary.text( summary.from + ' to '+ summary.to +' of '+ summary.total +' entries');
    },
    after_add: function(){
      var percent = this.data.length*100/2000;
      $record_count.text(percent + '%').attr('style', 'width:' + percent + '%');

      //Only for example: Stop ajax streaming beacause from localfile data size never going to empty.
      if (this.data.length == 2000){
        this.stopStreaming();
        $('.example .progress').removeClass('active').hide();
      }

    }
  }

  st = StreamTable('#stream_table',
    { view: view, 
      per_page: 10, 
      stream_after: 0.5,
      auto_sorting: true,
      fetch_data_limit: 100,
      callbacks: callbacks,
      pagination: {span: 5, next_text: 'Next &rarr;', prev_text: '&larr; Previous'}
    }
  , data);

  //Only for example: Stop ajax streaming beacause from localfile data size never going to empty.
  /*
  var timer = setTimeout(function(){
    st.clearTimer();
    $('.example .progress').removeClass('active').hide();
   }, 10*1000);
  */ 

});

