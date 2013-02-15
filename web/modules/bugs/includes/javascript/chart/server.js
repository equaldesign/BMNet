$(document).ready(function(){       
  $('#chartData-server').block();
   $.getJSON('/bugs/chartDataServer', function(data) {
    // Create the chart
    window.chart = new Highcharts.StockChart({
      chart : { 
        renderTo : 'chartData-server'
      },
      credits: {
          enabled: false
      },
      rangeSelector : {
        selected : 0
      }, 
      title : {
        text : 'Server Issues'
      },
       
      series : [{
        name : 'Server Errors',
        data : data,
        marker : {
          enabled : true,
          radius : 3
        },
        shadow : true
      }]
    });
    $('#chartData-server').unblock();
  });
})
