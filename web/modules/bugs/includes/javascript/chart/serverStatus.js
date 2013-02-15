$(document).ready(function(){       
  $('#chartData-server').block();
  $(".pop").popover();
   $.getJSON($.buildLink('pingdom.responseTimeChart'), function(data) {
    // Create the chart
    window.chart = new Highcharts.StockChart({
      chart : { 
        renderTo : 'chartData-server',
        backgroundColor: 'transparent'
      },
      credits: {
          enabled: false
      },
      rangeSelector : {
        selected : 0
      }, 
      title : {
        text : 'Server Status'
      },
      legend: {
          enabled: true
      },
			navigator: {
            top: 295
        },
      series : [
        {
	        name : 'Server 1',
	        data : data.SERVER1,
	        marker : {
	          enabled : true,
	          radius : 3
	        },
	        shadow : true
	      },{
	        name : 'Server 2',
	        data : data.SERVER2,
	        marker : {
	          enabled : true,
	          radius : 3
	        },
	        shadow : true
	      },{
	        name : 'Load Balancer',
	        data : data.LOADBALANCER,
	        marker : {
	          enabled : true,
	          radius : 3
	        },
	        shadow : true
	      },{
          name : 'Server 3',
          data : data.SERVER3,
          marker : {
            enabled : true,
            radius : 3
          },
          shadow : true
        }
			]
    });
    $('#chartData-server').unblock();
  });
  $('#chartData-average').block();
  $.getJSON($.buildLink('pingdom.responseTimeChart'), function(data) {
    // Create the chart
    server1Data = [];
    server2Data = [];
    server3Data = [];
    server4Data = [];
    for(i=8;i<=20;i++) {
      server1Data.push(data.SERVER1[i-1][1]);
      server2Data.push(data.SERVER2[i-1][1]);
      server3Data.push(data.SERVER3[i-1][1]);
      server4Data.push(data.LOADBALANCER[i-1][1]);
    }
    window.chart = new Highcharts.Chart({
        chart : {
            renderTo : 'chartData-average',
            backgroundColor: 'transparent',
            type: 'column'
        },
        credits: {
            enabled: false
        },
        rangeSelector : {
            selected : 0
        },
        title : {
            text : 'Average Response'
        },
        subtitle : {
            text: 'Average response per hour today'
        },
        xAxis: {
            categories: [
                '7 AM',
                '8 AM',
                '9 AM',
                '10 AM',
                '11 AM',
                '12 AM',
                '1 PM',
                '2 PM',
                '3 PM',
                '4 PM',
                '5 PM',
                '6 PM',
                '7 PM'
            ]
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Response Time (secs)'
            }
        },
        tooltip: {
            formatter: function() {
                return ''+
                    this.x +': '+ this.y +' secs';
            }
        },
        series : [
            {
                name : 'Server 1',
                data : server1Data

            },{
                name : 'Server 2',
                data : server2Data
            },{
                name : 'Server 3',
                data : server3Data
            },{
                name : 'Load Balancer',
                data : server4Data
            }
        ]
    });
    $('#chartData-average').unblock();
  });
});
