$(document).ready(function(){
	var targetAjax = "feed";  
	$.address.autoUpdate(true);
	$.address.init(function(event){
		$(".ajax").live("click",function(event) {
      var ref = $(this).attr("href");
      if (ref == undefined || ref == "#") {
        ref = $(this).attr("rel");
      }
			targetAjax = $(this).attr("rev");      
      $.address.value(ref);  
      return false;
    });
		if ($.address.value() == "/" || $.address.value() == "" || $.address.value() == "#") {
	   var dmsBaseURL = "/feed";
	   if (dmsBaseURL != "") {
	    $.address.value(dmsBaseURL);
	   }
		} else {
			$("#" + targetAjax).block();
        $.get(event.value, function(data){
          $("#" + targetAjax).html(data);
          $("#" + targetAjax).unblock();
        })
		}
	});
	$.address.externalChange(function(event) {         
	  
	  if (event.path != "/" && event.path != "" && event.path != "#") {
				if (Left(event.path, 2) == "#/" || Left(event.path, 1) == "/") {
					var winLoc = window.location.href;
          var end = winLoc.split("#");
          var str = end[1];
					if (event.value == str) {						
				  	$("#" + targetAjax).block();
				  	$.get(event.value, function(data){
				  		$("#" + targetAjax).html(data);
				  		$("#" + targetAjax).unblock();
				  	})
				  }
			}
		}     
	})


	
})