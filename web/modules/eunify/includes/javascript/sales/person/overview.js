$(document).ready(function(){
   google.load("visualization", "1", {packages:["corechart"],"callback":initCharts});
		 
	  
})
function initCharts() {
	var overViewdataURL = "/eunify/sales/chartData?dataType=salesPersonOverview&filterColumn=" + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val();
	var thisMonthdataURL = "/eunify/sales/chartData?dataType=salesPersonOverviewThisMonth&filterColumn=" + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val();
	var lastMonthdataURL = "/eunify/sales/chartData?dataType=salesPersonOverviewLastMonth&filterColumn=" + $("#filterColumn").val() + "&filterValue=" + $("#filterValue").val();
	$.ajax({
      url: overViewdataURL,
      dataType: "json",
      success: function(data) {
        var cdata = new google.visualization.DataTable();
        for (i=0;i<data.COLUMNS.length;i++) {
          if (i == 0) {
					 cdata.addColumn('string', data.COLUMNS[i]);
					} else {
					 cdata.addColumn('number', data.COLUMNS[i]);	
					}
					          
        }
        cdata.addRows(data.DATA.length);
        for (i=0;i<data.DATA.length;i++) {
          for (x=0;x<data.COLUMNS.length;x++) {
						if (x != 0) {
				      cdata.setValue(i, x, parseInt(data.DATA[i][x]));
			      } else {
				      cdata.setValue(i, x, data.DATA[i][x]);
			      }						
          }
        }
        var chart = new google.visualization.BarChart(document.getElementById('overviewChart'));
        chart.draw(cdata,
				  {
						width: "50%",
						fontSize: 10,
						chartArea: {
							top: 50,
							height:"90%"
						},
						colors: ["#99CC00","#006699"],
						backgroundColor:{
							fill: "#F9F9F9",
							stroke: "#DEDEDE",
							strokeWidth: 1
						}, 
						fontName: "Droid Sans",
						height: 800, 						
						title: "Performance this year",
						titleTextStyle: {
							fontSize: 22
						},
						hAxis: {
							viewWindowMode: "explicit",
							format: "£#,###,###",
              viewWindow: {
                min: 0
              }
						}
					});        
      }
    });
		
		$.ajax({
      url: thisMonthdataURL,
      dataType: "json",
      success: function(data) {
        var cdata = new google.visualization.DataTable();
        for (i=0;i<data.COLUMNS.length;i++) {
          if (i == 0) {
           cdata.addColumn('string', data.COLUMNS[i]);
          } else {
           cdata.addColumn('number', data.COLUMNS[i]);  
          }
                    
        }
        cdata.addRows(data.DATA.length);
        for (i=0;i<data.DATA.length;i++) {
          for (x=0;x<data.COLUMNS.length;x++) {
            if (x != 0) {
              cdata.setValue(i, x, parseInt(data.DATA[i][x]));
            } else {
              cdata.setValue(i, x, data.DATA[i][x]);
            }           
          }
        }
        var chart = new google.visualization.PieChart(document.getElementById('thisMonth'));
        chart.draw(cdata,
          {
            width: "50%",
            fontSize: 10,
            chartArea: {
              top: 50,
              height:"80%"
            },
            is3D: true,
            backgroundColor:{
              fill: "#F9F9F9",
              stroke: "#DEDEDE",
              strokeWidth: 1
            }, 
            fontName: "Droid Sans",
            height: 395,            
            title: "Top 10 Salesman this month",
            titleTextStyle: {
              fontSize: 16
            },
            hAxis: {
              viewWindowMode: "explicit",
              format: "£#,###,###",
              viewWindow: {
                min: 0
              }
            }
          });        
      }
    });
		
		$.ajax({
      url: lastMonthdataURL,
      dataType: "json",
      success: function(data) {
        var cdata = new google.visualization.DataTable();
        for (i=0;i<data.COLUMNS.length;i++) {
          if (i == 0) {
           cdata.addColumn('string', data.COLUMNS[i]);
          } else {
           cdata.addColumn('number', data.COLUMNS[i]);  
          }
                    
        }
        cdata.addRows(data.DATA.length);
        for (i=0;i<data.DATA.length;i++) {
          for (x=0;x<data.COLUMNS.length;x++) {
            if (x != 0) {
              cdata.setValue(i, x, parseInt(data.DATA[i][x]));
            } else {
              cdata.setValue(i, x, data.DATA[i][x]);
            }           
          }
        }
        var chart = new google.visualization.PieChart(document.getElementById('lastMonth'));
        chart.draw(cdata,
          {
            width: "50%",
						is3D: true,
            fontSize: 10,
            chartArea: {
              top: 50,
              height:"80%"
            },            
            backgroundColor:{
              fill: "#F9F9F9",
              stroke: "#DEDEDE",
              strokeWidth: 1
            }, 
            fontName: "Droid Sans",
            height: 395,            
            title: "Top 10 Salesman last month",
            titleTextStyle: {
              fontSize: 16
            },
            hAxis: {
              viewWindowMode: "explicit",
              format: "£#,###,###",
              viewWindow: {
                min: 0
              }
            }
          });        
      }
    });
}
