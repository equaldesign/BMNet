$(document).ready(function(){
	$("#changeDetails").submit(function() {		
		//wrap it up and submit via ajax
		jsonObject = new Object();
		jsonObject.preferences = {
		  "defaultSite": $("#defaultSite").val()
	  }
		jsonObject.organisation = $("#organisation").val();
		jsonObject.customData = new Object();
		$("#ajaxMain").block();
		$(".json").each(function(){
			jsonObject.customData[$(this).attr("name")] = $(this).val();
		})		
		$.ajax({
	      url: "/alfresco/service/profile/" + $("#userName").val() + "?alf_ticket=" + $("#alf_ticket").val(),
	      contentType: "application/json",
	      data: JSON.stringify(jsonObject),
	      dataType: "json",
	      type: "POST",
	      success: function (data) {					  
					$("#ajaxMain").unblock();					      			  			  
	      },
		  error: function(){
		   $("#ajaxMain").unblock();			  
		  }     
	  });
		return false;		
	})
})
