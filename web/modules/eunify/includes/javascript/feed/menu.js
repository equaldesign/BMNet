$(document).ready(function(){
	$.get("/eunify/calendar/index", function(data){
      $("#left_calendar").html(data);
  });
})
