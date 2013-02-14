$(document).ready(function(){    
	google.load("visualization", "1", {packages:["corechart"],"callback":initCharts});
});
function initCharts(){          
  $(".chart").each(function(){
		var chartDiv = $(this);	
		var cdata = new google.visualization.DataTable();		
		cdata.addColumn('string', 'Option');
		cdata.addColumn('number', 'Votes');
		var chartData = [];
		$(this).children(".chartName").each(function(){
			 chartData.push([$(this).attr("title"),parseInt($(this).attr("rel"))]);
		})
		cdata.addRows(chartData);
	  var options = {
			backgroundColor: { fill:'transparent' },
      width: 300, height: 300,
      title: $(chartDiv).attr("title")
    };         	 
	  var chart = new google.visualization.PieChart(document.getElementById($(chartDiv).attr("id")));
    chart.draw(cdata, options); 
	});   
 }