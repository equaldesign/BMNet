$(document).ready(function(){       
  $('#chartData-overview').block();
   $.getJSON('/bugs/chartDataOverview', function(data) {
    // Create the chart
    window.chart = new Highcharts.StockChart({
      chart : { 
        renderTo : 'chartData-overview'
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
        name : 'Tickets Opened',
        data : data,
        marker : {
          enabled : true,
          radius : 3
        },
        shadow : true
      }]
    });
    $('#chartData-overview').unblock();
  });
})
