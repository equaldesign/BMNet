$(document).ready(function(){
  $(".deletep").click(function(){
		var ok = window.confirm("Are you sure?");
		if (ok) {
			$.blockUI();
			$.ajax({
	      url: $(this).attr("href"),      
	      dataType: "json",
	      type: "DELETE",
	      success: function (data) {
	        window.history.go(0);      
	      }     
	    });
		}
		return false;
	})
	$(".publish").click(function(){
		$.blockUI();
    $.ajax({
      url: $(this).attr("href"),      
      dataType: "json",
      type: "POST",
      success: function (data) {
        window.history.go(0);      
      }     
    });
		return false;
	})
})
