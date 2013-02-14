$(document).ready(function(){
	$("#date").datepicker({
		dateFormat: "dd/mm/yy"
	});	
	$("#sched").click(function(){
		var chosenDate = $("#date").val();
		var dateParts = chosenDate.split("/");
		var alf_ticket = $("#alf_ticket").val();
		dyear = dateParts[2];
		dmonth = dateParts[1];
		dday = dateParts[0];
		$.ajax({
        url: "/alfresco/service/scheduleCall?nodeRef=" + $("#contactNodeRef").val() + "&alf_ticket=" + alf_ticket,
        dataType: "json",
        type: "POST",        
				data: {					
					type: "adhoc",
					dueDate: dmonth + "," + dday + "," + dyear + "06:00:00",
					desc: "Scheduled Call" 
				},
       success: function(data) {
         console.log(data) 
       }
     })				
	})
})
