$(document).ready(function(){	
	$.ajax({
	  url: $("#alphabet").attr("rel"),
	  type: "GET",       
	  dataType: "html",                        
	  success: function(data) {
			$("#customerpanel").html(data);
	  }
	})	
	$(".getcustomers").click(function(event){
		event.preventDefault();
		$.ajax({
	    url: $(this).attr("href"),
	    type: "GET",       
	    dataType: "html",                        
	    success: function(data) {
	     $("#customerpanel").html(data);   
	    }
    })
	})
})
