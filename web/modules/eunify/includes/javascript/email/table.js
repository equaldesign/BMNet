var oTable;
var giRedraw = false;
 
$(document).ready(function() {	
	$(".dataTable tbody").click(function(event) {        
				var td = $($(event.target.parentNode).find("td")[0]).find("img").attr("rel");				
				var ref = "/eunify/email/detail/id/" + td ;
				console.log(td);
        var targetWin = $(this).attr("rev");
	      if (targetWin == "" || targetWin == null) {
	        var win = $(this).closest(".ajaxWindow");
	        if (win.length == 0) {
						if ($(this).closest(".controlTarget").length == 0) {	           
              var windowName = "maincontent";
						} else {
							var windowName = $(this).closest(".controlTarget").attr("link-target");
							ref+= "?showExtra=false";
						}
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
	 oTable =  $('#emailList').dataTable( {
       "bJQueryUI": true,
        "sPaginationType": "full_numbers",
        "sDom": '<"reload"r><""l>t<"F"fp>',   
        "bAutoWidth":false, 
        "aaSorting": [[3,"desc"]],
				"bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "/eunify/email/list?contactID=" + $("#contactID").val() + "&companyID=" + $("#companyID").val(),        
        "iDisplayLength": 50,        
        "bStateSave": true        
    } );
	$('select').select2();   
} );
