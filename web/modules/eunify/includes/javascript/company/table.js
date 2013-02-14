var oTable;
var giRedraw = false;

$(document).ready(function() {
	$(".dataTable tbody td").live("click",function() {
		    var aPos = oTable.fnGetPosition( this );        
				var aData = oTable.fnGetData( aPos[0] );
				var account_number =aData[0];							
				var ref = "/eunify/company/detail/id/" + account_number;
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
     oTable =  $('.companyDataTable').dataTable( {
        "bJQueryUI": true,
        "sPaginationType": "full_numbers",
        "sDom": '<""l>t<"F"fp>',
				"bProcessing": true,
        "bServerSide": true,				
        "sAjaxSource": "/eunify/company/list/type_id/" + $("#type_id").val(),								
				"bStateSave": true,
				"iDisplayLength": 25,
				"aoColumnDefs": [ 
          {
						  "bVisible": false, "aTargets": [ 0 ] 
					}
        ]
     });		 
} );
