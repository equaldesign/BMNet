$(document).ready(function(){
	$("#emailSettings").submit(function() {    
    //wrap it up and submit via ajax
		var feedDisabled = true;
		if ($("#emailNotifications").is(":checked")) {
			feedDisabled = false;		
		}
    jsonObject = new Object();
    jsonObject.username = $("#userName").val();
		jsonObject.properties = new Object();
		jsonObject.properties["cm:emailFeedDisabled"] = feedDisabled;
    $("#ajaxMain").block();    
    $.ajax({
        url: "/alfresco/service/slingshot/profile/userprofile?alf_ticket=" + $("#alf_ticket").val(),
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
  $(".changeFeed").livequery("click",function(){
    var thisRow = $(this).closest(".media");
    jsonObject = new Object();
    jsonObject.siteId = $(this).attr("data-site");
    if ($(this).attr("data-appId") != "") {
      jsonObject.appToolId = $(this).attr("data-appId");  
    }
    $(thisRow).block();    
    if (!$(this).hasClass("active")) {
      $.ajax({
        url: "/alfresco/service/api/activities/feed/control?alf_ticket=" + $("#ticket").val(),
        contentType: "application/json",
        data: JSON.stringify(jsonObject),
        dataType: "json",
        type: "POST",
        success: function (data) {        
          $(thisRow).unblock();         
        },
        error: function(){
         $(thisRow).unblock();        
        }     
      });  
    } else {
      var delPath = "/alfresco/service/api/activities/feed/control?alf_ticket=" + $("#ticket").val() + "&s=" + jsonObject.siteId;
      if ($(this).attr("data-appId") != "") {
        delPath += "&a=" + jsonObject.appToolId;
      }
      $.ajax({
        url: delPath,
        contentType: "application/json",        
        dataType: "json",
        type: "DELETE",
        success: function (data) {        
          $(thisRow).unblock();         
        },
        error: function(){
         $(thisRow).unblock();        
        }     
      });  
    }
    
  })
});
