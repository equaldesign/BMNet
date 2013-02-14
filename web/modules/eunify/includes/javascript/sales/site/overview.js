$(document).ready(function(){  
   $("#overviewChart").block();
   $.getJSON('/eunify/sales/hchartData?filterColumn=' + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val(), function(data) {
    // Create the chart
    window.chart = new Highcharts.StockChart({
      chart : { 
        renderTo : 'overviewChart'
      },
      credits: {
          enabled: false
      },
      rangeSelector : {
        selected : 0
      }, 
      title : {
        text : 'Total Sales Turnover'
      },
       
      series : [{
        name : 'Sales Turnover',
        data : data,
        marker : {
          enabled : true,
          radius : 3
        },
        shadow : true,
        tooltip: {
          valueDecimals: 2,
					pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>£{point.y}</b>'          
        }
      }]
    });
		$("#overviewChart").unblock();
  });
});