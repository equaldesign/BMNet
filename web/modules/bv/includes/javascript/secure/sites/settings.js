$(document).ready(function(){   
  $('#colorPicker').colorpicker().on('changeColor', function(ev){    
    $(".navbar-inner").css("background",ev.color.toHex() + " !important");
  }); 
	$("#settingsForm").submit(function() {
    jsonObject = new Object();		
		jsonObject.customData = new Object();
    //wrap it up and submit via ajax
		$(".stcp").each(function(){
			if($(this).attr("type") == "checkbox") {
			 jsonObject.customData[$(this).attr("name")] = $(this).is(":checked");
			} else {
			 jsonObject.customData[$(this).attr("name")] = $(this).val();	
			}
      
		});
		$(".st").each(function(){
      if($(this).attr("type") == "checkbox") {
       jsonObject[$(this).attr("name")] = $(this).is(":checked");
      } else {
       jsonObject[$(this).attr("name")] = $(this).val(); 
      }
       
    });
    $("#ajaxMain").block();
    $.ajax({
        url: $("#settingsForm").attr("action"),
        contentType: "application/json",
        data: JSON.stringify(jsonObject),
        dataType: "json",
        type: "POST",
        success: function (data) { 
          $.get("/bv/admin/clearCacheKey?cacheKey=siteDetail" + $("#title").val());
          $("#ajaxMain").unblock();
          $.scrollTo(0);
					$("#updateComplete").show("slow");                       
        },
        error: function(){
         $("#ajaxMain").unblock();
         $.scrollTo(0);
				 $("#updateComplete").show("slow");  
        }     
      });
    return false;
  });  
})
