$(document).ready(function(){
	checkDealTools();
	$("#right_dealTools").load("/eunify/psa/menu/psaID/" + $("#psaID").val());	
	$(".doDiag").click(function(){
		var u = $(this).attr("href");
		$.ajax({ 
        url: u, 
        dataType: "html",
        
        success: function(data){
          $("#dialog").dialog({
            width: 700,
            height: 600,
            autoOpen: false
          });
          $("#dialog").dialog("option", "title", $(this).attr("title"));
          $("#dialog").html(data);
          $("#dialog").addClass("Aristo");
          $("#dialog").dialog( "option", "buttons",{});
            // bind form using 'ajaxForm' 
          $('#dialog').dialog('open');      
          //loadingWindow(false);
         }
       });
		return false;
	})	
})
