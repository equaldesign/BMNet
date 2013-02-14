$(function() {	
  $(".pushback").click(function(){
		var activityID = $(this).attr("data-id");
		var newDate = $(this).attr("data-time");				
		$.ajax({
			url: "/flo/activities/pushBack",
			data: {
				activityID: activityID,
				newDate: newDate
			}
		})
	})    
	$(".changePriority").click(function(){
		var thisE = this;
		var currentPriority = $(this).attr("data-priority");
		var activityID = $(this).attr("data-id");
		if (currentPriority > 1) {
			currentPriority--
		} else {
			currentPriority = 3;
		}
		$.ajax({
			url: "/flo/activities/changePriority",
			data: {
        activityID: activityID,
        priority: currentPriority
      },
			success: function() {
				$(thisE).attr("data-priority",currentPriority);
				switch (currentPriority) {
					case 1:
					  $(thisE).find("i").attr("class","icon-flag");						
					  break;
					case 2:
					  $(thisE).find("i").attr("class","icon-flag-yellow");
            break; 
				  case 3:
            $(thisE).find("i").attr("class","icon-flag-green");
            break;
				}
			}
		})
	})
});
