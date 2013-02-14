$(document).ready(function(){
	$('.rate').rating({
		callback: function(value, link){
			jsonObject = new Object();
	    $("#raitings").block();
	    jsonObject.rating = value;		
	    jsonObject.ratingScheme = "fiveStarRatingScheme";   
		  $.ajax({
		 	  url: $(this).attr("data-url"),
			  contentType: "application/json",
				data: JSON.stringify(jsonObject),
				dataType: "json",
				type: "POST",
				success: function (data) { 
				  $("#raitings").unblock();				                        
				},
				error: function(data) {
					$("#dialog").dialog({
			      title: "Sorry!",      
			      width: 300,
			      height: 200,
			      modal: true,        
			      buttons: {			        
			        "OK": {
			          "class": "btn btn-warning",
			          "text": "OK",
			          "click": function(){
			            $("#dialog").dialog("close");
			            $("#dialog").empty();
									$("#raitings").unblock(); 
			          } 
			         
			        } 
			      }       
			    })
					$("#dialog").empty();
			    $("#dialog").html('<strong>You cannot rate your own site!</strong><p>We\'re sure you\'d love to, but ratings are for users and not site managers!</p>')
			    $("#dialog").dialog("open");
				}
		  })		  
		}
	});
})
