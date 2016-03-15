var st; //For debuggin only

$(document).ready(function(){
  if ($('h2').text().includes("Start Exploring Campaign Finance in WA State")) {
    tablehook(gon.candidates.slice(0, 100), 'data');
    console.log("mainpage");
  } else if ($('h3').text().includes("Expenditures")) {
    console.log("expenditures");
    tablehook(gon.expenditures, 'expenditures_data');
  } else if ($('h3').text().includes("Contributions")) {
    console.log("contributions");
    tablehook(gon.contributions, 'contributions_data');
  };
});

var tablehook = function(data, data_url) {
  var html = $.trim($("#template").html())
  var template = Mustache.compile(html)
  var view = function(record, index){
    record.money_raised = accounting.formatMoney(record.raised);
    record.money_spent = accounting.formatMoney(record.spent);
    record.money_amount = accounting.formatMoney(record.amount);

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
      data_url: data_url,
      stream_after: 0.5,
      auto_sorting: true,
      fetch_data_limit: 500,
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

};
