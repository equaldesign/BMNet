$(document).ready(function(){	  
  var divName = "chartData-" + $("#status").val() + '-' + $("#chartType").val();
  $('#' + divName).block();
   $.getJSON('/bugs/chartData?status=' + $("#status").val() + '&filterBy=type&filterID=' + $("#chartType").val(), function(data) {
    // Create the chart
    window.chart = new Highcharts.StockChart({
      chart : { 
        renderTo : divName
      },
      credits: {
          enabled: false
      },
      rangeSelector : {
        selected : 0
      }, 
      title : {
        text : 'Support Issues'
      },
       
      series : [{
        name : 'Tickets ' + $("#status").val(),
        data : data,
        marker : {
          enabled : true,
          radius : 3
        },
        shadow : true
      }]
    });
    $('#'+ divName).unblock();
  });
})
