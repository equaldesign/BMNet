$(function() {
	
	// Build the chart
  $.getJSON("/marketing/email/chart/pie?id=" + $("#campaignDetail").attr("campaign-id"), function(data) {
	  // Radialize the colors
    
		chart = new Highcharts.Chart({
        chart: {
            renderTo: 'campaignPie',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
				title: {
            text: 'Out of ' + data.emailssent + ' emails that were sent'
        },
        tooltip: {					
				  headerFormat: "",
          pointFormat: '<b>{point.y} {point.name}</b>',
          percentageDecimals: 0
        },
				series: [data],
				credits: {
            enabled: false
        },
				
        plotOptions: {
          pie: {
             allowPointSelect: true,
             cursor: 'pointer',
             dataLabels: {
                enabled: true,
                color: '#000000',
                connectorColor: '#000000',
                formatter: function() {
                    return '<b>'+ this.point.name +'</b>: '+ this.percentage.toFixed(2) +' %';
                }
              },
              showInLegend: true
          }
        }        
    });
	});
	
  $("#campaignDetail").block();
	$.getJSON("/marketing/email/chart/overview?id=" + $("#campaignDetail").attr("campaign-id"), function(data) {
    chart = new Highcharts.StockChart({
        chart: {
            renderTo: 'campaignDetail'
        },
				credits: {
	          enabled: false
	      },
				
				legend: {
            enabled: true
        },	      
				navigator: {
            top: 295
        },
        series: data
    });  
  });
  $("#campaignDetail").unblock();
 
 
  
});
