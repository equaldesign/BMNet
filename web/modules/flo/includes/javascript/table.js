var oTable;
var giRedraw = false;
 
$(document).ready(function() {
   
   oTable =  $('.dataTable').dataTable( {
        "sDom": "<'widget-header'<'pull-left padd5'l><'pull-right padd5'f>r><'widget-content't><'widget-footer'<'pull-left padd5'i><'pull-right padd5'p>>",
        "sPaginationType": "bootstrap",
        "oLanguage": {
          "sLengthMenu": "_MENU_ records per page"
        },
        "iDisplayLength": 50,        
        "bStateSave": true				        
    } );   
	 $("#" + $(".dataTable").attr("id") + "_wrapper").prepend("<div class='widget-caption'>" + $(".dataTable").find("caption").text() + "</div>").find("#" + $(".dataTable").attr("id") + " caption").remove();
} );
