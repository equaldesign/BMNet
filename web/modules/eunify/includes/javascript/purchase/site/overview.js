$(document).ready(function(){  
	google.load("visualization", "1", {packages:["corechart"],"callback":initCharts});
});
function initCharts(){
	 var chartURL = "/eunify/sales/chartData?filterColumn=" + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val();
	 $.ajax({
      url: chartURL,
      dataType: "json",
      success: function(data){
			  	var cdata = new google.visualization.DataTable();
			  	
	  			cdata.addColumn('string', "ThisYear");					
					cdata.addColumn('number', "Last Year");
					cdata.addColumn('number', "This Year");
			  	cdata.addRows(data.DATA.length);
			  	for (i = 0; i < data.DATA.length; i++) {
						cdata.setValue(i,0,data.DATA[i][0].split(" ")[0]);						
		  			var val1 = (data.DATA[i][2] == "") ? 0 : data.DATA[i][2];
            var val2 = (data.DATA[i][3] == "") ? 0 : data.DATA[i][3];                       
            cdata.setCell(i,1,parseFloat(val1));
            cdata.setCell(i,2,parseFloat(val2));		  		
			  	}
			  	var formatter = new google.visualization.NumberFormat(
          {prefix: '£', negativeColor: 'red', negativeParens: true});
          formatter.format(cdata, 1); // Apply formatter to second column
          formatter.format(cdata, 2);
			  	var comboChart = new google.visualization.ComboChart(document.getElementById('overviewChart'));					
			  	comboChart.draw(cdata, {
			  		title: 'Year on Year Comparison',
						height: 400,
						fontSize: 12,
            chartArea: {
              top: 50,
              height:"80%"
            },
            colors: ["#99CC00","#006699"],
            backgroundColor:{
              fill: "#F9F9F9",
              stroke: "#DEDEDE",
              strokeWidth: 1
            }, 
            fontName: "Droid Sans",            
            titleTextStyle: {
              fontSize: 22
            },
            vAxis: {
              viewWindowMode: "explicit",
							title: "Turnover",
              format: "£#,###,###",
              viewWindow: {
                min: 0
              }
            },
			  		  	
			  		seriesType: "bars",
			  		series: {
			  			1: {
			  				type: "line"
			  			}
			  		}
			  	});
			  }
	  });
    $("#overviewTable").load("/eunify/sales/tableData?filterColumn=" + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val());
 }