var oTable;
var giRedraw = false;

$(document).ready(function() {
	$.fn.dataTableExt.oStdClasses.sPaging = "btn-group pull-right ";
  $.fn.dataTableExt.oStdClasses.sPagePrevEnabled   = "btn";
  $.fn.dataTableExt.oStdClasses.sPagePrevDisabled    = "btn btn-disabled";
  $.fn.dataTableExt.oStdClasses.sPageNextEnabled     = "btn";
  $.fn.dataTableExt.oStdClasses.sPageNextDisabled        = "btn btn-disabled";
  
  $.fn.dataTableExt.oStdClasses.sFilter       = "form form-inline pull-right";
  $.fn.dataTableExt.oStdClasses.sLength        = "form form-inline pull-left";
	var filterBy = $("#filterBy").val();
	var filterID = $("#filterID").val();
	$(".dataTable tbody").click(function(event) {        
				var td = $(event.target.parentNode).find("td")[0];
				var account_number = $(td).text();							
				var ref = "/eunify/ecommerce/detail/id/" + account_number;
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
   oTable =  $('#ecommerceList').dataTable( {
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "/eunify/ecommerce/query?filter=" + filterBy + "&filterid=" + filterID				
    } );
} );
