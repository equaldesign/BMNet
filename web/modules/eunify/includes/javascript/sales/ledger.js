var oTable;
var giRedraw = false;

$(document).ready(function() {
	var filterBy = $("#filterBy").val();
	var filterID = $("#filterID").val();
	$(".dataTable tbody").click(function(event) {      	       
				var aPos = oTable.fnGetPosition($(this).find("td")[0]);        
        var aData = oTable.fnGetData( aPos[0] );
        var invoice_id =aData[0]; 
				var ref = "/eunify/invoice/detail/id/" + invoice_id;
				console.log(invoice_id);
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
   oTable =  $('#ledger').dataTable( {
        "sDom": "<'widget-header'<'pull-left padd5'l><'pull-right padd5'f>r><'widget-content't><'widget-footer'<'pull-left padd5'i><'pull-right padd5'p>>",
        "sPaginationType": "bootstrap",
        "oLanguage": {
          "sLengthMenu": "_MENU_ records per page"
        },
				"bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "/eunify/sales/query",
				"aoColumnDefs": [ 
          {
              "bVisible": false, "aTargets": [ 0 ] 
          }
        ],       				
				"aaSorting": [[5,"desc"]]				
    } );
		$("#" + $("#ledger").attr("id") + "_wrapper").prepend("<div class='widget-caption'>" + $("#ledger").find("caption").text() + "</div>").find("#" + $("#ledger").attr("id") + " caption").remove();
} );
