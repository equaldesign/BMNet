$(document).ready(function(){
	$("#ColorPicker").ColorPicker();
  $("#modifySite").validate({
    rules: {
      title: "required"
    },
    messages: {      
      title: "A Title is required"      
    },
    submitHandler: function() {
    
      //wrap it up and submit via ajax
      jsonObject = new Object();
      $("#ajaxMain").block();
      jsonObject.title = $("#title").val();
      jsonObject.description = $("#description").val();      
			/*			
			 jsonObject.customProperties = new Object();
			 jsonObject.customProperties.headerColour = $("#ColorPicker").val();
			*/
      $.ajax({
          url: $("#modifySite").attr("action") + "?alf_ticket=" + $("#alf_ticket").val(),
          contentType: "application/json",
          data: JSON.stringify(jsonObject),
          dataType: "json",
          type: "PUT",
          success: function (data) { 
            $("#ajaxMain").unblock();
            $("#message").html("Site updated!");                               
          },
	        error: function(){
	         $("#ajaxMain").unblock();
	           $("#message").html("Site updated!");  
	        }     
        });
      return false;
    }
  })
})
