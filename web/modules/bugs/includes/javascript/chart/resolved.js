$(document).ready(function(){       
  $('#chartData-resolved').block();
   $.getJSON('/bugs/chartDataResolved', function(data) {
    // Create the chart
    window.chart = new Highcharts.StockChart({
      chart : { 
        renderTo : 'chartData-resolved'
      },
      credits: {
          enabled: false
      },
      rangeSelector : {
        selected : 0
      }, 
      title : {
        text : 'Resolved Issues'
      },
       
      series : [{
        name : 'Tickets Closed',
        data : data,
        marker : {
          enabled : true,
          radius : 3
        },
        shadow : true
      }]
    });
    $('#chartData-resolved').unblock();
  });
})
