$(document).ready(function(){
	var links = $("#figs > ul").find("li a");
  if (links.length != 0) {
  	var url = $.data(links[0], 'href.tabs');
  }        
  $("#dialog").dialog( "option", "buttons",{});
    $(".showcomments").click(function(){
      $.ajax({ 
        url:  $(this).attr("href"),        
        format: "html",
        success: function(data) {           
            $("#dialog").html(data);
            $("#dialog").dialog("open");
          }       
      });
      return false; 
    });
  $(".markpaid").change(function(){
		
    var thisWin = $(this).parentsUntil("div").parent();
    var val = $(this).val();
    var rel = $(this).attr("rel");
    var individualPayment = false;
    var element = $(this);		
    if (IsNumeric(rel)) {
      individualPayment = true;      
      var formData = {
        "paymentID":  rel,
        "paid": val 
      };			
      $.ajax({ 
        url:  "/eunify/comment/list",        
        data: {
          relatedID: $(this).attr("rel"),
          relatedType: "rebatePayments"
        },     
        format: "html",
        success: function(data) {           
            $("#dialog").html(data);
            $("#dialog").dialog("open");
          }       
      }); 
    } else {            
		  thisWin = $(this).closest(".ui-tabs-panel");
      var formData = {
        "paid": val
      };      
       var flags = rel.split("-");
       for (i in flags) {
        var vals = flags[i].split("_");
        formData[vals[0]] = vals[1];
      }
    }
    
  
    $.ajax({ 
      url:  $.buildLink("figures.rebatePaid"),
      method: "POST",
      data: formData,     
      format: "html",
      success: function(data) {
				if (!individualPayment) {
					var links = $("#figs > ul").find("li a");
					var url = $.data(links[0], 'href.tabs');
					var refreshUrl = url + "?fwCache=true";
					$.ajax({
						url: refreshUrl,
						format: "html",
						success: function(data){
						
							$(thisWin).html(data);
						}
					});
				} else {
          if (val == "true") {
            $(element).replaceWith('<img class="tooltip" title="Member has been paid" src="/images/icons/152.png">');
          } else if (val == "incorrect"){
            $(element).replaceWith('<img class="tooltip" title="Supplier paid incorrect amount" src="/images/icons/157.png">');
          } else {
            $(element).replaceWith('<img class="tooltip" title="Member has not been paid" src="/images/icons/151.png">');
          }         
        }         
      }
    });    
  });
});
function IsNumeric(input)
{
   return (input - 0) == input && input.length > 0;
}
