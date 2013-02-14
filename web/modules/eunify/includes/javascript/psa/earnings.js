$(document).ready(function(){
  $("#earnings").accordion({ 
    icons: false,     
    autoHeight: false, 
    collapsible: true, 
    active: false, 
    header: 'h3'
  });
	$(".recalculate").click(function() {      
      var thisWin = $(this).parentsUntil(".ui-tabs-panel").parent();
			$(thisWin).block();            
			var psaID = $(this).attr("id");
      $.get("/eunify/figures/recalculate?psaID=" + psaID, function(data){
        var links = $("#figs > ul").find("li a");
        var url = $.data(links[0], 'href.tabs');
        var refreshUrl = url + "?fwCache=true";   
				$.ajax({ 
          url:  refreshUrl,
          format: "html",
          success: function(data) {
						$(thisWin).unblock();             
            $(thisWin).html(data);             
          }
        });                     
      });
      return false;
  });
	
	
  
  $(".accordion").accordion('destroy').accordion({ autoHeight: false,collapsible: true,active: false, header: 'h5' });
	
  
})
function IsNumeric(input)
{
   return (input - 0) == input && input.length > 0;
}

