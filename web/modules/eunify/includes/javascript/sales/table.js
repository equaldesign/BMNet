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
	$(".dataTable tbody  td").click(function(event) {        
				var aPos = oTable.fnGetPosition( this );        
        var aData = oTable.fnGetData( aPos[0] );
        var invoice_id =aData[0]; 
        var ref = "/eunify/invoice/detail/id/" + invoice_id;
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
				"bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "/eunify/sales/query?filter=" + filterBy + "&filterid=" + filterID,
				"aoColumnDefs": [ 
          {
              "bVisible": false, "aTargets": [ 0 ] 
          }
        ]			
    } );
		$("#" + $("#customerList").attr("id") + "_wrapper").prepend("<div class='widget-caption'>" + $("#customerList").find("caption").text() + "</div>").find("#" + $("#customerList").attr("id") + " caption").remove();
} );
