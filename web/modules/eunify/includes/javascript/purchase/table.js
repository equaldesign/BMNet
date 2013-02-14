var oTable;
var giRedraw = false;

$(document).ready(function() {
	var filterBy = $("#filterBy").val();
	var filterID = $("#filterID").val();
	$(".dataTable tbody").click(function(event) {        
				var td = $(event.target.parentNode).find("td")[4];
				var account_number = $(td).text();							
				var ref = "/eunify/purchases/detail/id/" + account_number;
				console.log(account_number);
        var targetWin = $(this).attr("rev");
	      if (targetWin == "" || targetWin == null) {
	        var win = $(this).closest(".ajaxWindow");
	        if (win.length == 0) {
	          // it wasn't in a window, so assume it's #whiteBox
	          var windowName = "maincontent";
	        } else {
	          var windowName = $(win).attr("id"); 
	        }
	      } else {
	        var windowName = targetWin;           
	      }
	      // now stich the window Name and event together
	      var historyObject = [];
	      var uri = windowName + "!" + ref;           
	      
	      if (hashHistory[windowName] == undefined) {
	        //console.log(windowName + " is not defined in Array");
	        hashHistory[windowName] = new Array();
	      }
	      hashHistory[windowName][ref] = "";
	      document.location.href = "#!" + uri;
	      return false;
	    });	
   oTable =  $('#customerList').dataTable( {
        "sDom": "<'widget-header'<'pull-left padd5'l><'pull-right padd5'f>r><'widget-content't><'widget-footer'<'pull-left padd5'i><'pull-right padd5'p>>",
		    "sPaginationType": "bootstrap",
		    "oLanguage": {
		      "sLengthMenu": "_MENU_ records per page"
		    },
        "sAjaxSource": "/eunify/purchases/query?filter=" + filterBy + "&filterid=" + filterID,
				"iDeferLoading": 57
    } );
} );
