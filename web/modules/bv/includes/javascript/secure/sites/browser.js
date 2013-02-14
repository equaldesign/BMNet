$(document).ready(function(){
 $('.carousel').carousel();	
 $(".btn-group a.btn").click(function(){
		var uri = $(this).attr("href");
		$("#siteList").block();
		$.get(uri,function(data){
			$("#siteList").unblock();
			$("#siteList").html(data);
			$.scrollTo("350px",800);
		});
		return false;
	})
	$(".deleteSite").live("click",function(e){
    var jsonObject = {};
    var thisButton = this;
    e.preventDefault();
		
    var url = $(this).attr("href");
    $("#dialog").dialog({
      title: "Delete this site?",      
			width: 300,
			height: 200,
      modal: true,  			
      buttons: {
        "Delete": {
          "class": "btn btn-danger",
          "text": "Delete",
          "click": function() { 
            $.ajax({
				      url: url,
				        type: "DELETE",
				        dataType: "json",				          
				        success: function(data) {
				          $("#dialog").dialog("close");
									$("#dialog").empty();           
				        } 
				    })
          }                     
        }, 
        "Cancel": {
          "class": "btn",
          "text": "Cancel",
          "click": function(){
            $("#dialog").dialog("close");
						$("#dialog").empty(); 
          } 
         
        } 
      }       
    })
    $("#dialog").empty();
    $("#dialog").html('<strong>Are you sure?</strong><p>Deleting this site cannot be undone!</p>')
    $("#dialog").dialog("open");
    return false;
  })
	$(".joinSite").live("click",function(e){
		var jsonObject = {};
		var thisButton = this;
		e.preventDefault();
		jsonObject.role = "SiteConsumer";
		jsonObject.person = {};
		jsonObject.person.userName = $(this).attr("data-username");
		$(thisButton).text("processing...");
		
		$.ajax({
			url: $(this).attr("href"),
        type: "POST",
        dataType: "json",
				contentType: "application/json",
        data: JSON.stringify(jsonObject),         
        success: function(data) {
					$(thisButton).removeClass("btn-info");
					$(thisButton).removeClass("joinSite");
					$(thisButton).addClass("leaveSite");
					$(thisButton).addClass("btn-info");
					$(thisButton).text("Leave site")          
        } 
		})
		return false;
	})
	$(".requestAccess").live("click",function(e){
    var jsonObject = {};
		var thisButton = this;
    e.preventDefault();
    jsonObject.invitationType = "MODERATED";
    jsonObject.inviteeUserName = $(this).attr("data-username");
		jsonObject.inviteeRoleName = "Consumer";
		jsonObject.inviteeComments = ""; 
    $(thisButton).text("processing...")
    $.ajax({
      url: $(this).attr("href"),
        type: "POST",
        dataType: "json",
				contentType: "application/json",
        data: JSON.stringify(jsonObject),        
        success: function() {
          $(thisButton).removeClass("btn-info");
					$(thisButton).removeClass("requestAccess");
          $(thisButton).addClass("cancelAccess");
					$(thisButton).addClass("btn-warning");
          $(thisButton).text("Request sent.")          
        } 
    })
    return false;
  })
	$(".cancelAccess").live("click",function(e){
    var jsonObject = {};
    var thisButton = this;
    e.preventDefault();    
    $(thisButton).text("processing...")
    $.ajax({
      url: $(this).attr("href"),
        type: "GET",
        dataType: "json",        
        success: function() {
          $(thisButton).removeClass("btn-info");
					$(thisButton).removeClass("cancelAccess");
					$(thisButton).addClass("requestAccess");
          $(thisButton).addClass("btn-warning");
          $(thisButton).text("Request cancelled.")          
        } 
    })
    return false;
  })
	
	$(".leaveSite").live("click",function(e){    
    e.preventDefault();    
    $(this).text("processing...")
    $.ajax({
      url: $(this).attr("href"),
        type: "DELETE",
        dataType: "json",        
        success: function() {
          $(this).removeClass("btn-info");
          $(this).addClass("btn-info");
          $(this).text("Join site")          
        },
				error: function() {
					$(this).removeClass("btn-info");
          $(this).addClass("btn-success");
					$(thisButton).removeClass("leaveSite");
          $(thisButton).addClass("joinSite");
          $(this).text("Join site")
				} 
    })
    return false;
  })
});